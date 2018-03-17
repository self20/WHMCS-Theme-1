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
 * @version    1.3 (30/03/2017)
 * 
 * @since      1.2  Primary and Secondary navbars can be assigned from admin area
 *                  and automatically applied in client area.
 * @since      1.3 Menu Items can be displayed for specific client groups
 * @since      1.4 Fix minor bugs, implement template Six multilevel menu template that support upto 4 level
 * @since      1.5 Added "Store" default links
 */

if (!defined("WHMCS")){
    die("This file cannot be accessed directly");
}

# Init
use \Illuminate\Database\Capsule\Manager as Capsule;
use \Smarty;



function menumanager_config() {
    $configarray = array(
    "name" => "Advanced Menu Manager",
    "description" => "Easily manage your WHMCS menus, with advanced options, and new features.",
    "version" => "1.6.3",
    "author" => "<a href='http://www.modulescastle.com' target='_blank'>ModulesCastle</a>",
    "language" => "english",
    "fields" => array(
    ));
    return $configarray;
}

function menumanager_activate() {

    # Create DB Tables
    $queries = array();
	$queries[] = "CREATE TABLE IF NOT EXISTS `menumanager_groups` (
`id` int(11) unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `css_class` text COLLATE utf8_unicode_ci NOT NULL,
  `css_id` text COLLATE utf8_unicode_ci NOT NULL,
  `css_activeclass` text COLLATE utf8_unicode_ci NOT NULL,
  `template` text COLLATE utf8_unicode_ci NOT NULL,
  `isprimary` tinyint(1) NOT NULL DEFAULT '0',
  `issecondary` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;";
	$queries[] = "CREATE TABLE IF NOT EXISTS `menumanager_items` (
`id` int(11) unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `groupid` int(11) unsigned NOT NULL,
  `topid` int(11) unsigned NOT NULL DEFAULT '0',
  `parentid` int(11) unsigned NOT NULL DEFAULT '0',
  `title` text COLLATE utf8_unicode_ci NOT NULL,
  `url` text COLLATE utf8_unicode_ci NOT NULL,
  `urltype` text COLLATE utf8_unicode_ci NOT NULL,
  `reorder` smallint(3) unsigned NOT NULL DEFAULT '0',
  `accesslevel` smallint(3) unsigned NOT NULL DEFAULT '0',
  `targetwindow` enum('_self','_blank') COLLATE utf8_unicode_ci NOT NULL DEFAULT '_self',
  `badge` text COLLATE utf8_unicode_ci NOT NULL,
  `css_class` text COLLATE utf8_unicode_ci NOT NULL,
  `css_id` text COLLATE utf8_unicode_ci NOT NULL,
  `css_icon` text COLLATE utf8_unicode_ci NOT NULL,
  `datecreate` datetime NOT NULL,
  `datemodify` datetime NOT NULL,
  `attributes` text COLLATE utf8_unicode_ci NOT NULL,
  `language` text COLLATE utf8_unicode_ci NOT NULL,
  `clientgroups` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;";
    
	foreach ($queries as $query){
		Capsule::statement($query);
	}

    # Return Result
	return array(
				 'status' => 'success',
				 'description' => 'Advanced Menu Manager has been installed.');
}

function menumanager_deactivate() {

    # Remove DB Tables
    Capsule::statement("DROP TABLE `menumanager_groups`");
    Capsule::statement("DROP TABLE `menumanager_items`");

    # Return Result
    return array(
				 'status' => 'success',
				 'description' => 'Advanced Menu Manager module has been uninstalled.');
}

function menumanager_upgrade($vars) {
    $queries = array();
    
    # Since v1.2
    if (version_compare($vars['version'], '1.2', '<')){
        $queries[] = "ALTER TABLE `menumanager_groups` ADD `isprimary` TINYINT(1) NOT NULL DEFAULT '0' ;";
        $queries[] = "ALTER TABLE `menumanager_groups` ADD `issecondary` TINYINT(1) NOT NULL DEFAULT '0' ;";
    }
    
    # Since v1.3
    if (version_compare($vars['version'], '1.3', '<')){
        $queries[] = "ALTER TABLE `menumanager_items` ADD `clientgroups` TEXT NOT NULL ;";
    }
    
    foreach ($queries as $query){
        Capsule::statement($query);
	}
}

function menumanager_output($vars) {

	require_once(ROOTDIR . "/modules/addons/menumanager/libs/menumanager.class.php");

	define("MODURL", $vars['modulelink']);
	define("MODVERION", $vars['version']);

	global $CONFIG;
	global $templates_compiledir;

	# Init Smarty
	$smarty = new Smarty;
	$smarty->setCompileDir($templates_compiledir);
	$smarty->setTemplateDir(ROOTDIR . "/modules/addons/menumanager/templates/");
	$smarty->compile_id = md5(MODURL);
	
	# Init Main Class
	$menu = new MenuManager;
	$menu->displayTranslation = false;
	
	
	# Load Language Translation
	$_LANG = $menu->loadLanguageFile();
	$smarty->assign("_LANG", $_LANG);
	
	# Default Template
	$templateFile = "groups.tpl";
	
	# Assign Default Heading
	$smarty->assign("modPageTitle", "Menu Groups");
	
	$smarty->assign("modurl", MODURL);
	
	$menu->addToBreadCrumbs(MODURL, "Menu Groups");
	
	$action = trim($_GET['action']);
	$smarty->assign("action", $action);
	
	# Get Language Names
	$languages = $menu->getWHMCSLanguages();
	$smarty->assign("languages", $languages);
	$smarty->assign("totallanguages", count($languages));
	
	$menu->allAccessLevel = array(
		"0" => "Always disabled",
		"1" => "Always enabled",
		"2" => "Displayed for visitors only",
		"3" => "Displayed for clients only",
		"4" => "Displayed if client has active product(s)",
		"5" => "Displayed if client has overdue invoice(s)",
		"6" => "Displayed if client has active ticket(s)",
		"7" => "Displayed if client has active domain(s)",
		"8" => "Displayed if Manage Credit Card option is enabled",
		"9" => "Displayed if Add Funds option is enabled",
		"10" => "Displayed if Mass Payment option is enabled",
		"11" => "Displayed if Domain Registeration enabled",
		"12" => "Displayed if Domain Transfer enabled",
		"13" => "Displayes if Affiliate program enabled",
		"14" => "Displayes if Client is an affiliates",
		"15" => "Displayes if Client group is one of the selected groups",
	);
	
	# List Groups
	if ($action==""){

		# Get Compatible Templates Data
		include(ROOTDIR . "/modules/addons/menumanager/libs/compatibletemplates.php");
		$smarty->assign("compatibletemplates", $supportedTemplates);
		
		# Get Groups
		$getGroups = Capsule::table("menumanager_groups")
									->orderBy("id", "desc")
									->get();
		
		$groups = $menu->fromMYSQL($getGroups);
		
		$smarty->assign("groups", $groups);

	}
	
	# Add Group
	else if ($action=="addgroup"){
    
	    try {
	    
            $isPrimary = 0;
            $isSecondary = 0;
            
            if ($_POST['setas']=="primary"){
                $isPrimary = 1;
                Capsule::table("menumanager_groups")->update(array("isprimary" => 0));
            }
            if ($_POST['setas']=="secondary"){
                $isSecondary = 1;
                Capsule::table("menumanager_groups")->update(array("issecondary" => 0));
            }
            
    		$groupid = Capsule::table("menumanager_groups")->insertGetId(
    			array(
    				"name" => (string) trim($_POST['name']),
    			    "template" => (string) trim($_POST['template']),
    			    "css_class" => (string) trim($_POST['css_class']),
    			    "css_activeclass" => (string) trim($_POST['css_activeclass']),
    			    "css_id" => (string) trim($_POST['css_id']),
                    "isprimary" => intval($isPrimary),
                    "issecondary" => intval($isSecondary)
    			)
    		);
    		
    		# Install WHMCS Primary Navbar
    		if ($_POST['installdefault']=="primary"){
    			
    			$menu->installWHMCSPrimaryNavbar($groupid);
    			
    		}
    		
    		# Install WHMCS Secondary Navbar
    		if ($_POST['installdefault']=="secondary"){
    			
    			$menu->installWHMCSSecondaryNavbar($groupid);
    			
    		}
    		
    		# Redirect
    		$menu->redirect(MODURL.'&success=1');
    		exit;
    		
	    } catch (\Exception $e){
	        die("Error: " . $e->getMessage());
	    }

	}
	
	# Update Group
	else if ($action=="updategroup"){

	    try {
	    
    		$groupid = intval($_GET['id']);
            
            $isPrimary = 0;
            $isSecondary = 0;
            
            if ($_POST['setas']=="primary"){
                $isPrimary = 1;
                Capsule::table("menumanager_groups")->update(array("isprimary" => 0));
            }
            if ($_POST['setas']=="secondary"){
                $isSecondary = 1;
                Capsule::table("menumanager_groups")->update(array("issecondary" => 0));
            }
            
    		Capsule::table("menumanager_groups")
    		->where("id", $groupid)
    		->update(
    			array(
    			    "name" => (string) trim($_POST['name']),
    			    "template" => (string) trim($_POST['template']),
    			    "css_class" => (string) trim($_POST['css_class']),
    			    "css_activeclass" => (string) trim($_POST['css_activeclass']),
    			    "css_id" => (string) trim($_POST['css_id']),
                    "isprimary" => intval($isPrimary),
                    "issecondary" => intval($isSecondary)
    			)
    		);
    		
    		# Redirect
    		$menu->redirect(MODURL.'&success=1');
    		exit;
    	
	    } catch (\Exception $e){
	        die("Error: " . $e->getMessage());
	    }

	}
	
	# Delete Group
	else if ($action=="deletegroup"){

		$groupid = intval($_GET['id']);
		
		# Delete Group Record
		Capsule::table('menumanager_groups')
						->where("id", $groupid)
						->delete();
		
		# Delete Group Items
		Capsule::table('menumanager_items')
						->where("groupid", $groupid)
						->delete();
		
		# Redirect
		$menu->redirect(MODURL.'&success=1');
		exit;

	}
	
	# List Menu Items
	else if ($action=="listitems"){
		
        define("VIEWMENUASADMIN", true);
        
		$groupid = intval($_GET['groupid']);
		
		$getGroupInfo = Capsule::table('menumanager_groups')
        ->where("id", $groupid)
        ->get();
		$groupInfo = $menu->fromMYSQL($getGroupInfo);
		$smarty->assign("groupinfo", $groupInfo['0']);
		
		$templateFile = "menuitems.tpl";
		
		$menu->addToBreadCrumbs("", $groupInfo['0']['name']);
		
		$menuItemsList = array();
		
		$menu->displayFullURL = false;
		$menu->checkAccessability = true;
		$menuItemsList = $menu->generateMenu($groupid);
		
		$smarty->assign("items", $menuItemsList);
		$smarty->assign("countitems", count($menuItemsList));
		
	}
	
	# Add Item HTML
	elseif ($action=="additem"){
		
		$groupid = intval($_GET['groupid']);
		$smarty->assign("groupid", $groupid);
		
		# Get Group Info
		$getGroupInfo = Capsule::table('menumanager_groups')->where("id", $groupid)->get();
		$groupInfo = $menu->fromMYSQL($getGroupInfo);
		$smarty->assign("groupinfo", $groupInfo['0']);
		
		$templateFile = "menuitems.tpl";
		
		$menu->addToBreadCrumbs(MODURL . "&action=listitems&groupid=" . $groupInfo['0']['id'], $groupInfo['0']['name']);
		$menu->addToBreadCrumbs('', "New Menu Item");
		
		# Get Menu Items Level1
		$getMenuItems = Capsule::table("menumanager_items")
										->where("groupid", $groupid)
										->where("parentid", 0)
										->where("topid", 0)
										->orderBy("reorder", "asc")
										->select("id", "title")
										->get();
		$level1 = $menu->fromMYSQL($getMenuItems);
		# Get Menu Items Level2
		foreach ($level1 as $index1 => $menulevel1){
			$getMenuItemsLevel2 = Capsule::table("menumanager_items")
											->where("parentid", $menulevel1['id'])
											->where("topid", 0)
											->orderBy("reorder", "asc")
											->select("id", "title")
											->get();
			$level2 = $menu->fromMYSQL($getMenuItemsLevel2);
			# Get Menu Items Level3
			foreach ($level2 as $index2 => $menulevel2){
				$getMenuItemsLevel3 = Capsule::table("menumanager_items")
											->where("parentid", $menulevel2['id'])
											->where("topid", 0)
											->orderBy("reorder", "asc")
											->select("id", "title")
											->get();
				$level3 = $menu->fromMYSQL($getMenuItemsLevel3);
				$level2[$index2]['sub'] = $level3;
				unset($level3);
			}
			$level1[$index1]['sub'] = $level2;
			unset($level2);
			
			# Final
			$menuItemsList = $level1;
		}
		$smarty->assign("parentlist", $menuItemsList);
		
		# Get Support Departments
		$getSupportDepartments = Capsule::table("tblticketdepartments")
											->orderBy("id", "asc")
											->select("id", "name")
											->get();
		$smarty->assign("supportdepartments", $menu->fromMYSQL($getSupportDepartments));
		
		
	}
	
	# Add Menu Item
	else if ($action=="doadditem"){
		
	    try {
		
	        $groupid = intval($_POST['groupid']);
    		$parentid = intval($_POST['parentid']);
    		$urltype = $_POST['urltype'];
    		
    		$attributes = array();
    		
    		# Attributes
    		foreach ($_POST['attrnames'] as $index => $attributename){
    			if ($attributename!=''){
    				$attributes[$attributename] = $_POST['attrvalues'][$index];
    			}
    		}
    		
    		# Get Reorder Number for This Item
    		$getReorder = Capsule::table("menumanager_items")
    								->where('groupid', $groupid)
    								->where('parentid', $parentid)
    								->where('topid', 0)
    								->orderBy('reorder', 'desc')
    								->select('reorder')
    								->take(1)
    								->get();
    		$reorder = $menu->fromMYSQL($getReorder);
    		$newReorder = intval($reorder['0']['reorder']) + 1;
    		
    		# Save Item + Attributes
    		$itemID = Capsule::table("menumanager_items")
    							->insertGetId(
    								array(
    									"groupid" => intval($groupid),
    									"parentid" => intval($parentid),
    									"topid" => 0,
    								    "title" => (string) trim($_POST['title']),
    								    "url" => (string) $_POST[$urltype],
    								    "urltype" => (string) $urltype,
    								    "targetwindow" => (string) $_POST['targetwindow'],
    									"reorder" => intval($newReorder),
    									"accesslevel" => intval($_POST['accesslevel']),
    								    "badge" => (string) $_POST['badge'],
    								    "css_class" => (string) $_POST['css_class'],
    								    "css_id" => (string) $_POST['css_id'],
    								    "css_icon" => (string) $_POST['css_icon'],
    									"datecreate" => date("Y-m-d H:i:s"),
    									"datemodify" => date("Y-m-d H:i:s"),
    								    "language" => (string) strtolower($CONFIG['Language']),
    									"attributes" => serialize($attributes),
                                        "clientgroups" => (string) join(",", $_POST['clientgroups'])
    								)
    							);
    		
    		# Save Translations
    		if (is_array($_POST['translation_languages'])){
    			foreach($_POST['translation_languages'] as $index => $languagename){
    				if ($_POST['translation_title'][$languagename]!=''){
    					Capsule::table('menumanager_items')
    								->insert(
    									array(
    										"groupid" => intval($groupid),
    										"topid" => intval($itemID),
    										"parentid" => intval($parentid),
    									    "title" => (string) $_POST['translation_title'][$languagename],
    									    "language" => (string) $languagename,
    										"datecreate" => '0000-00-00 00:00:00',
    										"datemodify" => '0000-00-00 00:00:00'
    									)
    								);
    				}
    			}
    		}
    		
    		
    		# Return Admin To the Same Page If he clicked "Save", and return him to Group menu item if "Save and Close"
    		if (isset($_POST['save']) && $_POST['save']=="save"){
    			$menu->redirect(MODURL . '&action=edititem&itemid='.$itemID);
    		} else {
    			$menu->redirect(MODURL . '&action=listitems&groupid='.$groupid);
    		}
    		
    		exit;
    	
	    } catch (\Exception $e){
	        die("Error: " . $e->getMessage());
	    }
		
	}
	
	# Edit Item
	else if ($action=="edititem"){
		
		$itemid = intval($_GET['itemid']);
		$smarty->assign("itemid", $itemid);
		
		$defaultLanguage = strtolower($CONFIG['Language']);
		
		# Get Item Info
		$getItemInfo = Capsule::table('menumanager_items')->where("id", $itemid)->get();
		$itemInfo = $menu->fromMYSQL($getItemInfo);
		$itemInfo['0']['datecreate'] = date("dS M, Y H:s", strtotime($itemInfo['0']['datecreate']));
		$itemInfo['0']['datemodify'] = date("dS M, Y H:s", strtotime($itemInfo['0']['datemodify']));
		
		# Get Item Translations
		$itemtranslations = array();
		$getItemTranslations = Capsule::table('menumanager_items')->where("topid", $itemid)->select('id', 'title', 'language')->get();
		foreach ($menu->fromMYSQL($getItemTranslations) as $index => $data){
			$itemtranslations['title'][$data['language']] = $data['title'];
			$itemtranslations['records'][] = $data['language'].'-'.$data['id'];
		}
		if (!in_array($itemInfo['0']['language'], $itemtranslations['title'])){
			$itemtranslations['title'][$itemInfo['0']['language']] = $itemInfo['0']['title'];
		}
		if ($itemInfo['0']['language']!=$defaultLanguage && $itemtranslations['title'][$defaultLanguage]!=''){
			$itemInfo['0']['title'] = $itemtranslations['title'][$defaultLanguage];
			unset($itemtranslations['title'][$defaultLanguage]);
		}
		$smarty->assign("itemtranslations", $itemtranslations);
		$smarty->assign("totaltranslations", count($itemtranslations['title']));
		$smarty->assign("itemtranslationrecords", join(",", $itemtranslations['records']));
		$smarty->assign("iteminfo", $itemInfo['0']);
		
		# Parse Attributes
		$attributes = array();
		$getAttributes = unserialize($itemInfo['0']['attributes']);
		foreach ($getAttributes as $name => $value){
			$attributes[] = array("name" => $name, "value" => $value);
		}
		$smarty->assign("attributes", $attributes);
		
		# Get Group Info
		$getGroupInfo = Capsule::table('menumanager_groups')->where("id", $itemInfo['0']['groupid'])->get();
		$groupInfo = $menu->fromMYSQL($getGroupInfo);
		$smarty->assign("groupinfo", $groupInfo['0']);
		
		# Get Support Departments
		$getSupportDepartments = Capsule::table("tblticketdepartments")
											->orderBy("id", "asc")
											->select("id", "name")
											->get();
		$smarty->assign("supportdepartments", $menu->fromMYSQL($getSupportDepartments));
		
        # Get Client Groups
        $getClientGroups = Capsule::table("tblclientgroups")->get();
        $smarty->assign("clientgroups", $menu->fromMYSQL($getClientGroups));
        
        # Get Selected Client Groups
        $getSelectedClientGroups = explode(",", $itemInfo['0']['clientgroups']);
        $smarty->assign("selectedclientgroups", $getSelectedClientGroups);
        
		$templateFile = "menuitems.tpl";
		
		$menu->addToBreadCrumbs(MODURL . "&action=listitems&groupid=" . $groupInfo['0']['id'], $groupInfo['0']['name']);
		$menu->addToBreadCrumbs('', "Update: ". $itemInfo['0']['title']);
		
		

	}
	
	# Update Item Data
	elseif ($action=='doedititem'){
        
	    try {
	    
    		$attributes = array();
    		
    		# Attributes
    		foreach ($_POST['attrnames'] as $index => $attributename){
    			if ($attributename!=''){
    				$attributes[$attributename] = $_POST['attrvalues'][$index];
    			}
    		}
    		
    		# Save Item Changes
    		Capsule::table('menumanager_items')
    					->where('id', $_POST['itemid'])
    					->update(
    						array(
    						    "title" => (string) trim($_POST['title']),
    						    "url" => (string) $_POST[$_POST['urltype']],
    						    "urltype" => (string) $_POST['urltype'],
    							"accesslevel" => intval($_POST['accesslevel']),
    						    "targetwindow" => (string) $_POST['targetwindow'],
    						    "badge" => (string) $_POST['badge'],
    						    "css_class" => (string) $_POST['css_class'],
    						    "css_id" => (string) $_POST['css_id'],
    						    "css_icon" => (string) $_POST['css_icon'],
    							"datemodify" => date("Y-m-d H:i:s"),
    							"attributes" => serialize($attributes),
    						    "language" => (string) strtolower($CONFIG['Language']),
                                "clientgroups" => (string) join(",", $_POST['clientgroups'])
    						)
    					);
    		
    		# Translation IDs
    		$translationRecords = explode(",", $_POST['translationrecords']);
    		foreach($translationRecords as $record){
    			$splitRecord = explode("-", $record);
    			$translationIDs[$splitRecord['0']] = $splitRecord['1'];
    		}
    		
    		if (is_array($_POST['translation_languages'])){
    			foreach($_POST['translation_languages'] as $index => $languagename){
    				if ($_POST['translation_title'][$languagename]!=''){
    					# Save New Translation
    					if (array_key_exists($languagename, $translationIDs)){
    						Capsule::table('menumanager_items')
    								->where('id', $translationIDs[$languagename])
    								->update(
    									array(
    									    "title" => (string) $_POST['translation_title'][$languagename],
    										"datecreate" => '0000-00-00 00:00:00',
    										"datemodify" => '0000-00-00 00:00:00'
    									)
    								);
    						unset($translationIDs[$languagename]);
    					}
    					# Update Current Translations
    					else {
    						Capsule::table('menumanager_items')
    								->insert(
    									array(
    										"groupid" => intval($_POST['groupid']),
    										"topid" => intval($_POST['itemid']),
    										"parentid" => intval($_POST['parentid']),
    										"title" => (string) $_POST['translation_title'][$languagename],
    										"language" => (string) $languagename,
    										"datecreate" => '0000-00-00 00:00:00',
    										"datemodify" => '0000-00-00 00:00:00'
    									)
    								);
    					}
    					
    				}
    			}
    		}
    		# Delete Other Translations
    		foreach ($translationIDs as $lang => $recordid){
    			Capsule::table('menumanager_items')->where('id', $recordid)->delete();
    		}
    		
    		# Return Admin To the Same Page If he clicked "Save", and return him to Group menu item if "Save and Close"
    		if (isset($_POST['save']) && $_POST['save']=="save"){
    			$menu->redirect(MODURL . '&action=edititem&itemid='.$_POST['itemid']);
    		} else {
    			$menu->redirect(MODURL . '&action=listitems&groupid='.$_POST['groupid']);
    		}
    		
    		exit;
		
	    } catch (\Exception $e){
	        die("Error: " . $e->getMessage());
	    }
		
	}
	
	# Save Reorder
	elseif ($action=='reorder'){
		
		$orderlevel1 = 1;
		$orderlevel2 = 1;
		$orderlevel3 = 1;
		$orderlevel4 = 1;
		
		foreach ($_POST['items'] as $index => $level1){
			
			# Update Level #1
			Capsule::table("menumanager_items")
						->where("id", $level1['id'])
						->update(
							array(
								"parentid" => 0,
								"reorder" => intval($orderlevel1)
							)
						);
			
			# Update Level #2
			if (is_array($level1['children'])){
				$orderlevel2 = 1;
				foreach ($level1['children'] as $index => $level2){
				Capsule::table("menumanager_items")
							->where("id", $level2['id'])
							->update(
								array(
									"parentid" => $level1['id'],
									"reorder" => intval($orderlevel2)
								)
							);
				$orderlevel2++;
				
					# Update Level #3
					if (is_array($level2['children'])){
						$orderlevel3 = 1;
						foreach ($level2['children'] as $index => $level3){
						Capsule::table("menumanager_items")
									->where("id", $level3['id'])
									->update(
										array(
											"parentid" => $level2['id'],
											"reorder" => intval($orderlevel3)
										)
									);
						$orderlevel3++;
						
							# Update Level #4
							if (is_array($level3['children'])){
								$orderlevel4 = 1;
								foreach ($level3['children'] as $index => $level4){
								Capsule::table("menumanager_items")
											->where("id", $level4['id'])
											->update(
												array(
													"parentid" => $level3['id'],
													"reorder" => intval($orderlevel4)
												)
											);
								$orderlevel4++;
								}
							}
						}
					}
				}
			}
			
			$orderlevel1++;
		}
		
		exit;
		
	}
	
	# Delete Item
	elseif ($action=='deleteitem'){
		
		$itemid = intval($_GET['id']);
		$groupid = intval($_GET['groupid']);
		
		Capsule::table("menumanager_items")
					->where('id', $itemid)
					->orWhere('topid', $itemid)
					->orWhere('parentid', $itemid)
					->delete();
		
		$menu->redirect(MODURL . '&action=listitems&groupid='.$groupid);
		
		exit;
		
	}
	
	$smarty->assign("breadcrumbs", $menu->getBreadCrumbs());
	
	# Finally Display Output
	$smarty->display("header.tpl");
		$smarty->display($templateFile);
	$smarty->display("footer.tpl");
	

}

function menumanager_sidebar($vars) {
}

