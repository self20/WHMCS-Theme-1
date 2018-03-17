<?php
/**
 * WHMCS Advanced Menu Manager
 *
 *
 * @package    ModulesCastle
 * @author     ModulesCastle <info@modulescastle.com>
 * @copyright  Copyright (c) ModulesCastle 2015-2017
 * @link       http://www.modulescastle.com/
 * @link       http://codecanyon.net/user/ModulesCastle
 * @version    1.2
 * @since      1.2 Primary and Secondary navbars can be assigned from admin area,
 * @since      1.6.3 Fix 3rd and 4th levels in automatice integration 
 * and automatically applied in client area.
 */

use Illuminate\Database\Capsule\Manager as Capsule;
use WHMCS\View\Menu\Item as MenuItem;
use Smarty;

require_once(ROOTDIR . "/modules/addons/menumanager/libs/menumanager.class.php");

# Load Files in Admin Area
function MenuManagerHook_loadAdminAreaFiles($vars){
    $HTML = '';
    
    # Only Applied In Our Module
    if ($vars['filename']=="addonmodules" && $_GET['module']=="menumanager"){
        # Sortable Plugin
        $HTML .= '<script type="text/javascript" src="../modules/addons/menumanager/assets/plugins/sortable/sortable.js"></script>';
        # Our Styles / Scripts
        $HTML .= '<link type="text/css" rel="stylesheet" href="../modules/addons/menumanager/assets/css/styles.css">';
        $HTML .= '<script type="text/javascript" src="../modules/addons/menumanager/assets/js/scripts.js"></script>';
    }

return $HTML;
}
add_hook("AdminAreaHeadOutput", 1, "MenuManagerHook_loadAdminAreaFiles");


# Generate FrontEnd Menus
function MenuManagerHook_generateMenus($vars){
    
    require_once(ROOTDIR . "/modules/addons/menumanager/libs/compatibletemplates.php");
    
    global $templates_compiledir;
    
    # Init Smarty
	$smarty = new Smarty;
	$smarty->setCompileDir($templates_compiledir);
	$smarty->setTemplateDir(ROOTDIR . "/modules/addons/menumanager/clientarea/");
	$smarty->compile_id = md5(MODURL);
    
    $menu = new MenuManager;
    $menu->displayTranslation = true;
    $menu->toLanguage = $menu->detectClientAreaLanguage();
    $menu->initMenuItemAccess($vars);
    $menu->initMenuItemBadge($vars);
    
    # Assign Values to Smarty
    $menu->assignToSmarty['clientfirstname'] = $vars['clientsdetails']['firstname'];
    $menu->assignToSmarty['clientlastname'] = $vars['clientsdetails']['lastname'];
    
    $menuIntegrationCode = array();
    
    
    # Get Groups
    $getMenuGroups = Capsule::table("menumanager_groups")->get();
    $menuGroups = $menu->fromMYSQL($getMenuGroups);

    foreach ($menuGroups as $group){
        
        $varialbleName = "menumanager_".$group['id'];
        
        # Assign Group
        $smarty->assign("group", $group);
        
        # Generate Menu Items
        $menuItems = $menu->generateMenu($group['id']);
        $smarty->assign('menu', $menuItems);
        
        $templateFile = $supportedTemplates[$group['template']]['file'];
        
        # Load Menu Group Template
        $menuHTML = $smarty->fetch("file:".$templateFile);
        
        
        $menuIntegrationCode[$varialbleName] = $menuHTML;
    }
    
    return $menuIntegrationCode;
}
add_hook("ClientAreaPage", 1, "MenuManagerHook_generateMenus");


# Replace Primary Navbar
add_hook("ClientAreaPrimaryNavbar", 1000000000, function (MenuItem $primaryNavbar){
    
    $client = Menu::context("client");
    
    # Check If Category Exist
    $isPrimarySet = Capsule::table("menumanager_groups")->where("isprimary", "=", 1);
    
    # Menu Category Doesn't Exist
    if ($isPrimarySet->count()===0){
        return true;
    }
    
    # Delete Exist Primary Menu Items
    if (!is_null($primaryNavbar->getChildren())) {
        
        foreach ($primaryNavbar->getChildren() as $menuItem){
            $primaryNavbar->removeChild($menuItem->getName());
        }
        
    } 
    
    $menu = new MenuManager;
    $menu->displayTranslation = true;
    $menu->toLanguage = $menu->detectClientAreaLanguage();
    
    # Assign Values to Smarty
    $menu->assignToSmarty['clientfirstname'] = $client->firstname;
    $menu->assignToSmarty['clientlastname'] = $client->lastname;
    
    $getPrimaryNavbar = $isPrimarySet->get();
    $getPrimaryNavbar = (array) $getPrimaryNavbar[0];
    
    $menu = $menu->generateMenu($getPrimaryNavbar['id']);
    
    $itemMarkedActive = false;
    
    $levelOneObject = null;
    $levelOneCounter = 0;
    
    # Level 1
    foreach ($menu as $level1){
        
        $levelOneObject = $primaryNavbar->addChild( "level_1_" . $level1['id'] );
        $levelOneObject->setLabel( html_entity_decode($level1['title']) );
        $levelOneObject->setURI( $level1['fullurl'] );
        $levelOneObject->setOrder( $levelOneCounter );
        $levelOneObject->setAttribute( "target", $level1['targetwindow'] );
        foreach ($level1['attributes_array'] as $name => $value){
            $levelOneObject->setAttribute( $name, $value );
        }
        $itemClasses = array();
        if ($level1['isactive']==true && $itemMarkedActive===false){
            $itemMarkedActive = true;
            $itemClasses[] = $getPrimaryNavbar['css_activeclass'];
        }
        if (!empty($level1['css_class'])){
            $itemClasses[] = trim($level1['css_class']);
        }
        $levelOneObject->setClass( join(" ", $itemClasses) );
        
        if (!empty($level1['badge']) && $level1['badge']!=="none"){
            $levelOneObject->setBadge( $level1['badge'] );
        }
        if (is_string($level1['css_icon']) && !empty($level1['css_icon'])){
            $levelOneObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level1['css_icon'])) );
        }
        
        # Divider
        if (in_array(strtolower($level1['title']), array("-----", "------", "divider"))){
            $levelOneObject->setClass("nav-divider");
            $levelOneObject->setLabel("");
            $levelOneObject->setURI("#");
            $levelOneObject->setBadge("");
            $levelOneObject->setIcon("");
        }
        
        # Level 2
        if (is_array($level1['children']) && count($level1['children'])>0){
            
            $levelTwoObject = null;
            $levelTwoCounter = 0;
            
            foreach ($level1['children'] as $level2){
                
                $levelTwoObject = $levelOneObject->addChild( "level_2_" . $level2['id'] );
                $levelTwoObject->setLabel( html_entity_decode($level2['title']) );
                $levelTwoObject->setURI( $level2['fullurl'] );
                $levelTwoObject->setOrder( $levelTwoCounter );
                $levelTwoObject->setAttribute( "target", $level2['targetwindow'] );
                foreach ($level2['attributes_array'] as $name => $value){
                    $levelTwoObject->setAttribute( $name, $value );
                }
                $itemClasses = array();
                if ($level2['isactive']==true && $itemMarkedActive===false){
                    $itemMarkedActive = true;
                    $itemClasses[] = $getPrimaryNavbar['css_activeclass'];
                }
                if (!empty($level2['css_class'])){
                    $itemClasses[] = trim($level2['css_class']);
                }
                $levelTwoObject->setClass( join(" ", $itemClasses) );
                
                if (!empty($level2['badge']) && $level2['badge']!=="none"){
                    $levelTwoObject->setBadge( $level2['badge'] );
                }
                if (is_string($level2['css_icon']) && !empty($level2['css_icon'])){
                    $levelTwoObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level2['css_icon'])) );
                }
                
                if (in_array(strtolower($level2['title']), array("-----", "------", "divider"))){
                    $levelTwoObject->setClass("nav-divider");
                    $levelTwoObject->setLabel("");
                    $levelTwoObject->setURI("#");
                    $levelTwoObject->setBadge("");
                    $levelTwoObject->setIcon("");
                }
                
                $levelTwoCounter++;
                
                
                # Level 3
                if (is_array($level2['children']) && count($level2['children'])>0){
                    
                    $levelThreeObject = null;
                    $levelThreeCounter = 0;
                    
                    foreach ($level2['children'] as $level3){
                        
                        $levelThreeObject = $levelTwoObject->addChild( "level_3_" . $level3['id'] );
                        $levelThreeObject->setLabel( html_entity_decode($level3['title']) );
                        $levelThreeObject->setURI( $level3['fullurl'] );
                        $levelThreeObject->setOrder( $levelThreeCounter );
                        $levelThreeObject->setAttribute( "target", $level3['targetwindow'] );
                        foreach ($level3['attributes_array'] as $name => $value){
                            $levelThreeObject->setAttribute( $name, $value );
                        }
                        $itemClasses = array();
                        if ($level3['isactive']==true && $itemMarkedActive===false){
                            $itemMarkedActive = true;
                            $itemClasses[] = $getPrimaryNavbar['css_activeclass'];
                        }
                        if (!empty($level3['css_class'])){
                            $itemClasses[] = trim($level3['css_class']);
                        }
                        $levelThreeObject->setClass( join(" ", $itemClasses) );
                        
                        if (!empty($level3['badge']) && $level3['badge']!=="none"){
                            $levelThreeObject->setBadge( $level3['badge'] );
                        }
                        if (is_string($level3['css_icon']) && !empty($level3['css_icon'])){
                            $levelThreeObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level3['css_icon'])) );
                        }
                        
                        # Divider
                        if (in_array(strtolower($level3['title']), array("-----", "------", "divider"))){
                            $levelThreeObject->setClass("nav-divider");
                            $levelThreeObject->setLabel("");
                            $levelThreeObject->setURI("#");
                            $levelThreeObject->setBadge("");
                            $levelThreeObject->setIcon("");
                        }
                        
                        $levelThreeCounter++;
                        
                        
                        # Level 4
                        if (is_array($level3['children']) && count($level3['children'])>0){
                            
                            $levelFourObject = null;
                            $levelFourCounter = 0;
                            
                            foreach ($level3['children'] as $level4){
                                
                                $levelFourObject = $levelThreeObject->addChild( "level_4_" . $level4['id'] );
                                $levelFourObject->setLabel( html_entity_decode($level4['title']) );
                                $levelFourObject->setURI( $level4['fullurl'] );
                                $levelFourObject->setOrder( $levelFourCounter );
                                $levelFourObject->setAttribute( "target", $level4['targetwindow'] );
                                foreach ($level4['attributes_array'] as $name => $value){
                                    $levelFourObject->setAttribute( $name, $value );
                                }
                                $itemClasses = array();
                                if ($level4['isactive']==true && $itemMarkedActive===false){
                                    $itemMarkedActive = true;
                                    $itemClasses[] = $getPrimaryNavbar['css_activeclass'];
                                }
                                if (!empty($level4['css_class'])){
                                    $itemClasses[] = trim($level4['css_class']);
                                }
                                $levelFourObject->setClass( join(" ", $itemClasses) );
                                
                                if (!empty($level4['badge']) && $level4['badge']!=="none"){
                                    $levelFourObject->setBadge( $level4['badge'] );
                                }
                                if (is_string($level4['css_icon']) && !empty($level4['css_icon'])){
                                    $levelFourObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level4['css_icon'])) );
                                }
                                
                                # Divider
                                if (in_array(strtolower($level4['title']), array("-----", "------", "divider"))){
                                    $levelFourObject->setClass("nav-divider");
                                    $levelFourObject->setLabel("");
                                    $levelFourObject->setURI("#");
                                    $levelFourObject->setBadge("");
                                    $levelFourObject->setIcon("");
                                }
                                
                                $levelFourCounter++;
                            }
                            
                        } // Level 4
                    
                    }
                    
                } // Level 3
                
            } 
            
        } // Level 2
        
        $levelOneCounter++;
        
    } // Level 1
    
});


# Replace Secondary Navbar
add_hook("ClientAreaSecondaryNavbar", 1000000000, function (MenuItem $secondaryNavbar){

    $client = Menu::context("client");
    
    # Check If Category Exist
    $isSecondarySet = Capsule::table("menumanager_groups")->where("issecondary", "=", 1);
    
    # Menu Category Doesn't Exist
    if ($isSecondarySet->count()===0){
        return true;
    }
    
    # Delete Exist Secondary Menu Items
    if (!is_null($secondaryNavbar->getChildren())) {
        
        foreach ($secondaryNavbar->getChildren() as $menuItem){
            $secondaryNavbar->removeChild($menuItem->getName());
        }
        
    } 
    
    $menu = new MenuManager;
    $menu->displayTranslation = true;
    $menu->toLanguage = $menu->detectClientAreaLanguage();
    
    # Assign Values to Smarty
    $menu->assignToSmarty['clientfirstname'] = $client->firstname;
    $menu->assignToSmarty['clientlastname'] = $client->lastname;
    
    $getSecondaryNavbar = $isSecondarySet->get();
    $getSecondaryNavbar = (array) $getSecondaryNavbar[0];
    
    $menu = $menu->generateMenu($getSecondaryNavbar['id']);
    
    $itemMarkedActive = false;
    
    $levelOneObject = null;
    $levelOneCounter = 0;
    
    # Level 1
    foreach ($menu as $level1){
        
        $levelOneObject = $secondaryNavbar->addChild( "level_1_" . $level1['id'] );
        $levelOneObject->setLabel( html_entity_decode($level1['title']) );
        $levelOneObject->setURI( $level1['fullurl'] );
        $levelOneObject->setOrder( $levelOneCounter );
        $levelOneObject->setAttribute( "target", $level1['targetwindow'] );
        foreach ($level1['attributes_array'] as $name => $value){
            $levelOneObject->setAttribute( $name, $value );
        }
        $itemClasses = array();
        if ($level1['isactive']==true && $itemMarkedActive===false){
            $itemMarkedActive = true;
            $itemClasses[] = $getSecondaryNavbar['css_activeclass'];
        }
        if (!empty($level1['css_class'])){
            $itemClasses[] = trim($level1['css_class']);
        }
        $levelOneObject->setClass( join(" ", $itemClasses) );
        
        if (!empty($level1['badge']) && $level1['badge']!=="none"){
            $levelOneObject->setBadge( $level1['badge'] );
        }
        if (is_string($level1['css_icon']) && !empty($level1['css_icon'])){
            $levelOneObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level1['css_icon'])) );
        }
        
        # Divider
        if (in_array(strtolower($level1['title']), array("-----", "------", "divider"))){
            $levelOneObject->setClass("nav-divider");
            $levelOneObject->setLabel("");
            $levelOneObject->setURI("#");
            $levelOneObject->setBadge("");
            $levelOneObject->setIcon("");
        }
        
        # Level 2
        if (is_array($level1['children']) && count($level1['children'])>0){
            
            $levelTwoObject = null;
            $levelTwoCounter = 0;
            
            foreach ($level1['children'] as $level2){
                
                $levelTwoObject = $levelOneObject->addChild( "level_2_" . $level2['id'] );
                $levelTwoObject->setLabel( html_entity_decode($level2['title']) );
                $levelTwoObject->setURI( $level2['fullurl'] );
                $levelTwoObject->setOrder( $levelTwoCounter );
                $levelTwoObject->setAttribute( "target", $level2['targetwindow'] );
                foreach ($level2['attributes_array'] as $name => $value){
                    $levelTwoObject->setAttribute( $name, $value );
                }
                $itemClasses = array();
                if ($level2['isactive']==true && $itemMarkedActive===false){
                    $itemMarkedActive = true;
                    $itemClasses[] = $getSecondaryNavbar['css_activeclass'];
                }
                if (!empty($level2['css_class'])){
                    $itemClasses[] = trim($level2['css_class']);
                }
                $levelTwoObject->setClass( join(" ", $itemClasses) );
                
                if (!empty($level2['badge']) && $level2['badge']!=="none"){
                    $levelTwoObject->setBadge( $level2['badge'] );
                }
                if (is_string($level2['css_icon']) && !empty($level2['css_icon'])){
                    $levelTwoObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level2['css_icon'])) );
                }
                
                if (in_array(strtolower($level2['title']), array("-----", "------", "divider"))){
                    $levelTwoObject->setClass("nav-divider");
                    $levelTwoObject->setLabel("");
                    $levelTwoObject->setURI("#");
                    $levelTwoObject->setBadge("");
                    $levelTwoObject->setIcon("");
                }
                
                $levelTwoCounter++;
                
            
                # Level 3
                if (is_array($level2['children']) && count($level2['children'])>0){
                    
                    $levelThreeObject = null;
                    $levelThreeCounter = 0;
                    
                    foreach ($level2['children'] as $level3){
                        
                        $levelThreeObject = $levelThreeObject->addChild( "level_3_" . $level3['id'] );
                        $levelThreeObject->setLabel( html_entity_decode($level3['title']) );
                        $levelThreeObject->setURI( $level3['fullurl'] );
                        $levelThreeObject->setOrder( $levelThreeCounter );
                        $levelThreeObject->setAttribute( "target", $level3['targetwindow'] );
                        foreach ($level3['attributes_array'] as $name => $value){
                            $levelThreeObject->setAttribute( $name, $value );
                        }
                        $itemClasses = array();
                        if ($level3['isactive']==true && $itemMarkedActive===false){
                            $itemMarkedActive = true;
                            $itemClasses[] = $getSecondaryNavbar['css_activeclass'];
                        }
                        if (!empty($level3['css_class'])){
                            $itemClasses[] = trim($level3['css_class']);
                        }
                        $levelThreeObject->setClass( join(" ", $itemClasses) );
                        
                        if (!empty($level3['badge']) && $level3['badge']!=="none"){
                            $levelThreeObject->setBadge( $level3['badge'] );
                        }
                        if (is_string($level3['css_icon']) && !empty($level3['css_icon'])){
                            $levelThreeObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level3['css_icon'])) );
                        }
                        
                        # Divider
                        if (in_array(strtolower($level3['title']), array("-----", "------", "divider"))){
                            $levelThreeObject->setClass("nav-divider");
                            $levelThreeObject->setLabel("");
                            $levelThreeObject->setURI("#");
                            $levelThreeObject->setBadge("");
                            $levelThreeObject->setIcon("");
                        }
                        
                        $levelThreeCounter++;
                        
                    
                        # Level 4
                        if (is_array($level3['children']) && count($level3['children'])>0){
                            
                            $levelFourObject = null;
                            $levelFourCounter = 0;
                            
                            foreach ($level3['children'] as $level4){
                                
                                $levelFourObject = $levelFourObject->addChild( "level_4_" . $level4['id'] );
                                $levelFourObject->setLabel( html_entity_decode($level4['title']) );
                                $levelFourObject->setURI( $level4['fullurl'] );
                                $levelFourObject->setOrder( $levelFourCounter );
                                $levelFourObject->setAttribute( "target", $level4['targetwindow'] );
                                foreach ($level4['attributes_array'] as $name => $value){
                                    $levelFourObject->setAttribute( $name, $value );
                                }
                                $itemClasses = array();
                                if ($level4['isactive']==true && $itemMarkedActive===false){
                                    $itemMarkedActive = true;
                                    $itemClasses[] = $getSecondaryNavbar['css_activeclass'];
                                }
                                if (!empty($level4['css_class'])){
                                    $itemClasses[] = trim($level4['css_class']);
                                }
                                $levelFourObject->setClass( join(" ", $itemClasses) );
                                
                                if (!empty($level4['badge']) && $level4['badge']!=="none"){
                                    $levelFourObject->setBadge( $level4['badge'] );
                                }
                                if (is_string($level4['css_icon']) && !empty($level4['css_icon'])){
                                    $levelFourObject->setIcon( str_replace(array("fa ", "glyphicon "), "", trim($level4['css_icon'])) );
                                }
                                
                                # Divider
                                if (in_array(strtolower($level4['title']), array("-----", "------", "divider"))){
                                    $levelFourObject->setClass("nav-divider");
                                    $levelFourObject->setLabel("");
                                    $levelFourObject->setURI("#");
                                    $levelFourObject->setBadge("");
                                    $levelFourObject->setIcon("");
                                }
                                
                                $levelFourCounter++;
                            }
                            
                        } // Level 4
                        
                    }
                    
                } // Level 3
                
            }
            
        } // Level 2
        
        $levelOneCounter++;
        
    }
    
});
