<?php
/**
 * WHMCS Advanced Menu Manager
 *
 *
 * @package     ModulesCastle
 * @author      ModulesCastle <info@modulescastle.com>
 * @copyright   Copyright (c) ModulesCastle 2015-2017
 * @link        http://www.modulescastle.com/
 * @link        http://codecanyon.net/user/ModulesCastle
 * @version     1.3     (30/03/2017)
 * 
 * @since       1.2     Primary and Secondary navbars can be assigned from admin area,
 *                      and automatically applied in client area.
 * @since       1.3     Menu Items can be displayed for specific client groups
 * @since       1.4 Fix minor bugs, implement template Six multilevel menu template that support upto 4 level
 * @since       1.5 Added "Store" default links
 */

use Illuminate\Database\Capsule\Manager as Capsule;
use WHMCS\View\Menu\Item as MenuItem;

if (!class_exists("MenuManager")){

class MenuManager {
    
	/**
	 * Hold BreadCrumbs
	 */
    public $breadCrumbs = array();
	
	/**
	 * true  = Display Absolute URL (http(s)://demo.whmcs.com/filename.php?param1=value)
	 * false = Display Relative URL (filename.php?param1=value)
	 */
	public $displayFullURL = true;
	
	/**
	 * List Of Access Levels Values
	 */
	public $accessLevels = array();
	
	/**
	 * Check Access Level of Items
	 * false when calling it from admin area
	 */
	public $checkAccessability = true;
    
	/**
	 * Display Translation
	 * false when calling it from admin area
	 */
	public $displayTranslation = true;
	
	/**
	 * Translate Items to this language
	 */
	public $toLanguage = '';
    
    public $clientTotals = null;
	
	/**
	 * Hold Client Statistics to be used as Badge
	 */
	public $badges = array();
	
	public $assignToSmarty = array();
	
	public $allAccessLevel = array();
	
	public function __construct(){
        
        $this->initMenuItemBadge();
        
        $this->initMenuItemAccess();
        
	}
	
    /**
     * Detect User/Admin Interface Language
     */
    public static function detectClientAreaLanguage(){
        
        global $CONFIG;
        
        # Detect Language
        if (isset($_SESSION['Language']) && $_SESSION['Language']!=''){
            $detectedLanguage = strtolower($_SESSION['Language']);
        } else {
            $detectedLanguage = strtolower($CONFIG['Language']);
        }
        
        return $detectedLanguage;
    }
	
	/**
     * Detect User/Admin Interface Language
     */
    public static function detectUserInterfaceLanguage(){
        
        global $CONFIG;
        
        # Detect Language
        if (isset($_SESSION['Language']) && $_SESSION['Language']!=''){
            $detectedLanguage = strtolower($_SESSION['Language']);
        } else {
            $detectedLanguage = strtolower($CONFIG['Language']);
        }
        # Get Language File
        if (!file_exists(ROOTDIR . '/modules/addons/menumanager/languages/'.$detectedLanguage.'.php')){
            $detectedLanguage = 'english';
        }
        
        return $detectedLanguage;
    }
    
    # Load Module Language File
    public static function loadLanguageFile(){
        
        $detectedLanguage = MenuManager::detectUserInterfaceLanguage();
        
        # Get Language File
        include (ROOTDIR . '/modules/addons/menumanager/languages/'.$detectedLanguage.'.php');
        
        # Load Language File Overrides If Exist
        if (file_exists(ROOTDIR . '/modules/addons/menumanager/languages/overrides/'.$detectedLanguage.'.php')){
            include (ROOTDIR . '/modules/addons/menumanager/languages/overrides/'.$detectedLanguage.'.php');
        }
        
        return $_LANG;
    }
    
    /**
     * Add New URL To BreadCrumbs
     */
    public function addToBreadCrumbs($url, $title){

        $this->breadCrumbs[$url] = $title;

    }
    
    /**
     * Get BreadCrumbs URLs as HTML Formated
     */
    public function getBreadCrumbs(){

        $list = $this->breadCrumbs;

        $newList = '<ol class="breadcrumb">';

        foreach($list as $url => $title){
            if ($url==''){
                $newList .= '<li class="active">' . $title . '</li>';
            } else {
                $newList .= '<li><a href="' . $url . '">' . $title . '</a></li>';
            }
        }
        
        $newList .= '</ol>';
        
        return $newList;
    }
    
    /**
     * Handle MySQL Reponse
     */
    public static function fromMYSQL($result){
        $encoded = json_encode($result);
		
		$array = json_decode($encoded, true);
        
        return $array;
    }
    
    /**
     * Redirect To URL
     */
    public static function redirect($url=MODURL, $delay=0){
        echo '<META HTTP-EQUIV="Refresh" CONTENT="'.$delay.'; URL='.$url.'">';
    }
	
	/**
     * Return Array With All Files Exist Inside Specified Folder
     *
     * @access Public
     * @param  String $path Define Relative Path To Read Its Content
     * @param  Array  Add Array With File Names To Be Excluded From the Return List
     * @return Array  Contain List Of File Names
     */
    public static function getFolderFiles($path, $exclude = array()){
        
        $fileList = array();
        
        # Exclude ".", ".." from list
        array_push($exclude, ".", "..");
    
        # Read Directory
        $openDir = new DirectoryIterator($path);
        
        # Loop All Items Found Inside
        foreach ($openDir as $item){
            # Only List Valid Files also Exclude unwanted ones
            if (!in_array($item->getFileName(), $exclude) && $item->isFile()==true){
                $fileList[] = $item->getFileName();
            }
        }
        
        return $fileList;
    }
	
	/**
	 * Get WHMCS Languages
	 */
	public function getWHMCSLanguages(){
		global $CONFIG;
		
		$defaultLanguage = $CONFIG['Language'].'.php';
		
		$files = $this->getFolderFiles(ROOTDIR . '/lang/', array('index.php', 'README.txt', $defaultLanguage));
		
		$languageList = array();
		
		foreach ($files as $file){
			$splitFile = explode(".", $file);
			if ($splitFile['1']=="php"){
				$languageList[] = strtolower($splitFile['0']);
			}
		}
		
		return $languageList;
	}
	
	/**
	 * FrontEnd Menu
	 */
	public function generateMenu($groupid){
		
		# Get Group Info
		$groupInfo = Capsule::table("menumanager_groups")->where('id', $groupid)->get();
		
		# Get Menu Items
		$menu = $this->getMenuItems($groupid, 0);
		
		return $menu;
		
	}
    
	/**
	 * Get Menu Item
	 */
	public function getMenuItems($groupid, $parentid){
		
		global $CONFIG;
		
		$defaultLanguage = strtolower($CONFIG['Language']);
		
		# Get Menu Info
		$getMenuInfo = Capsule::table("menumanager_items")
							->where("groupid", $groupid)
							->where("parentid", $parentid)
							->where("topid", 0)
							->orderBy("reorder", "asc")
							->get();
		
		$menuInfo = MenuManager::fromMYSQL($getMenuInfo);
		
		foreach ($menuInfo as $index => $menuItem){
			
			if ($this->checkMenuItemAccess($menuItem['accesslevel'], $menuItem['clientgroups'])===false && defined("VIEWMENUASADMIN")!==true){
				unset($menuInfo[$index]);
				continue;
			}
			
			# Get Menu Item Translation
			$getMenuTranslation = Capsule::table("menumanager_items")
									->where('topid', $menuItem['id'])
									->where('language', $this->toLanguage)
									->get();
			
			$menuTranslation = MenuManager::fromMYSQL($getMenuTranslation);
			if ($menuTranslation['0']['title']!='' && $this->displayTranslation===true){
				$menuInfo[$index]['title'] = $menuTranslation['0']['title'];
			}
			
			# Fetch Menu Title As Smarty
			global $smarty;
			if (is_object($smarty)){
                foreach ($this->assignToSmarty as $var => $value){
                    $smarty->assign($var, $value);
                }
                $menuInfo[$index]['title'] = $smarty->fetch("string:" . $menuInfo[$index]['title']);
			}
			
			# Parse Attributes
			$parseAttributes = unserialize($menuItem['attributes']);
			$menuAttributes = array();
            $menuAttributesArray = array();
			foreach ($parseAttributes as $name => $value){
				$menuAttributes[] = $name . '="' . $value . '"';
                $menuAttributesArray[ $name ] = $value;
			}
			$menuInfo[$index]['attributes'] = join(" ", $menuAttributes);
            $menuInfo[$index]['attributes_array'] = $menuAttributesArray;
			
			# Parse URL
			$menuInfo[$index]['fullurl'] = $this->parseMenuItemURL($menuItem);
            
            # Check If menu is Current/Active
            $menuInfo[$index]['isactive'] = false;
            if ($this->isMenuItemActive($menuInfo[$index]['fullurl'])===0){
                $menuInfo[$index]['isactive'] = true;
            }
			
			# Get Menu Item Badge
			$menuInfo[$index]['badge'] = $this->getMenuItemBadge($menuItem['badge']);
			
			# Explain Access Level for Admin
			$menuInfo[$index]['accesslevelexplain'] = $this->allAccessLevel[$menuItem['accesslevel']];
			
			# Get Sub Menu
			$menuInfo[$index]['children'] = $this->getMenuItems($groupid, $menuItem['id']);
			
		}
		
		return $menuInfo;
	}
	
	/**
	 * Parse Menu Item URL
	 */
	public function parseMenuItemURL($item){
		
		global $CONFIG;
		
		$systemURL = rtrim($CONFIG['SystemURL'], "/") . '/';
		
		# Get System URL
		if ($CONFIG['SystemSSLURL']!=''){
			$systemURL = rtrim($CONFIG['SystemSSLURL'], "/") . '/';
		}
		
		if ($this->displayFullURL===false){
			$systemURL = "";
		}
		
		# ClientArea URLs
		if (in_array($item['urltype'], array("clientarea-on", "clientarea-off"))){
			$URL = $systemURL . urldecode($item['url']);
		}
		elseif ($item['urltype']=="support"){
			$URL = $systemURL . 'submitticket.php?step=2&deptid=' . intval($item['url']);
		}
		else {
			$URL = trim($item['url']);
		}
		
		return $URL;
	}
	
	/**
	 * Check Menu Access Level
	 */
	public function checkMenuItemAccess($menuAccess, $menuClientGroups){
		
        $client = Menu::context("client");
        
		# Force Menu Item to be displayed, Ignore accessability check
		if ($this->checkAccessability===false){
			return true;
		}
		
        # Menu Item Specified For Selected Client Groups
        if ($menuAccess===15){
            $getClientGroups = explode(",", $menuClientGroups);
            if (is_array($getClientGroups) && count($getClientGroups)>0){
                # Client is in one of the selected groups
                if (in_array($client->groupid, $getClientGroups)){
                    return true;
                }
                else {
                    return false;
                }
            }
            # No Client Groups Specified, turn to "Enabled for clients only"
            else {
                $menuAccess = 3;
            }
        }
        
		return $this->accessLevels[$menuAccess];
		
	}
	
	/**
	 * Init Menu Access Level
	 */
    /*
	public function initMenuItemAccessOld($vars){
		
		$clientid = intval($_SESSION['uid']);
		
		$accessLevels = array(
			"0" => false, // Always Disabled
			"1" => true, // Always Enabled
			"2" => false, // Enabled for visitors only
			"3" => false, // Enabled for clients only
			"4" => false, // Active Product(s)
			"5" => false, // Overdue Invoice(s)
			"6" => false, // Active Ticket(s)
			"7" => false, // Active Domain(s)
			"8" => false, // Manage Credit Cards
			"9" => false, // Add Funds
			"10" => false, // Mass Pay
			"11" => false, // Domain Registration
			"12" => false, // Domain Transfer
			"13" => false, // Affiliates Setting Enabled
			"14" => false, // Client is Affiliate
		);
		
		# Is Normal Visitor
		if ($clientid=='0'){
			$accessLevels['2'] = true;
		}
		# Client Logged-in
		elseif ($clientid!='0'){
			$accessLevels['3'] = true;
		}
		
		# Active Products
		if (intval($vars['clientsstats']['productsnumactive'])>0){
			$accessLevels['4'] = true;
		}
		
		# Overdue Invoices
		if (intval($vars['clientsstats']['numoverdueinvoices'])>0){
			$accessLevels['5'] = true;
		}
		
		# Active Tickets
		if (intval($vars['clientsstats']['numactivetickets'])>0){
			$accessLevels['6'] = true;
		}
		
		# Active Domains
		if (intval($vars['clientsstats']['numactivedomains'])>0){
			$accessLevels['7'] = true;
		}
		
		# Manage Credit Cards
		if (intval($vars['condlinks']['updatecc'])!='0'){
			$accessLevels['8'] = true;
		}
		
		# Add Funds
		if ($vars['condlinks']['addfunds']=="on"){
			$accessLevels['9'] = true;
		}
		
		# Mass Pay
		if ($vars['condlinks']['masspay']=="on"){
			$accessLevels['10'] = true;
		}
		
		# Domain Registration
		if ($vars['condlinks']['domainreg']=="on"){
			$accessLevels['11'] = true;
		}
		
		# Domain Transfare
		if ($vars['condlinks']['domaintrans']=="on"){
			$accessLevels['12'] = true;
		}
		
		# Affiliate Program is On
		if ($vars['condlinks']['affiliates']=="on"){
			$accessLevels['13'] = true;
		}
        
        # Affiliate Program is On
		if ($vars['clientsstats']['isAffiliate']===true){
			$accessLevels['14'] = true;
		}
		
		
		$this->accessLevels = $accessLevels;
		
	}
	*/
    
	/**
	 * Init Menu Access Level
	 */
	public function initMenuItemAccess(){
		
		$client = Menu::context("client");
		
		$accessLevels = array(
			"0" => false, // Always Disabled
			"1" => true, // Always Enabled
			"2" => false, // Enabled for visitors only
			"3" => false, // Enabled for clients only
			"4" => false, // Active Product(s)
			"5" => false, // Overdue Invoice(s)
			"6" => false, // Active Ticket(s)
			"7" => false, // Active Domain(s)
			"8" => false, // Manage Credit Cards
			"9" => false, // Add Funds
			"10" => false, // Mass Pay
			"11" => false, // Domain Registration
			"12" => false, // Domain Transfer
			"13" => false, // Affiliates Setting Enabled
			"14" => false, // Client is Affiliate
            "15" => false, // Client Assigned to Group
		);
		
		# Is Normal Visitor
		if ($client->id === null){
			$accessLevels['2'] = true;
		}
		# Client Logged-in
		elseif ($client->id !== null){
			$accessLevels['3'] = true;
		}
        
		# Active Products
		if ($this->getClientTotals('activeservices')>0){
			$accessLevels['4'] = true;
		}
		
		# Overdue Invoices
		if ($this->getClientTotals('overdueinvoices')>0){
			$accessLevels['5'] = true;
		}
		
		# Active Tickets
		if ($this->getClientTotals('activetickets')>0){
			$accessLevels['6'] = true;
		}
		
		# Active Domains
		if ($this->getClientTotals('activedomains')>0){
			$accessLevels['7'] = true;
		}
        
		# Manage Credit Cards
		if ($CONFIG['CCNeverStore']!="on"){
			$accessLevels['8'] = true;
		}
		
		# Add Funds
		if ($CONFIG['AddFundsEnabled']=="on"){
			$accessLevels['9'] = true;
		}
		
		# Mass Pay
		if ($CONFIG['EnableMassPay']=="on"){
			$accessLevels['10'] = true;
		}
		
		# Domain Registration
		if ($CONFIG['AllowRegister']=="on"){
			$accessLevels['11'] = true;
		}
		
		# Domain Transfare
		if ($CONFIG['AllowTransfer']=="on"){
			$accessLevels['12'] = true;
		}
		
		# Affiliate Program is On
		if ($CONFIG['AffiliateEnabled']=="on"){
			$accessLevels['13'] = true;
		}
        
        # Affiliate Program is On
		if ($client->affiliate!==null && $client->id!==null){
			$accessLevels['14'] = true;
		}
		
		$this->accessLevels = $accessLevels;
		
	}
	
	/**
	 * Init Menu Badge
	 */
    /*
	public function initMenuItemBadgeOld($vars){
		
		$clientid = intval($_SESSION['uid']);
		
		$badges = array(
			"totalservices" => intval($vars['clientsstats']['productsnumtotal']),
			"activeservices" => intval($vars['clientsstats']['productsnumactive']) . ' ('. intval($vars['clientsstats']['productsnumtotal']) .')',
			"totaldomains" => intval($vars['clientsstats']['numdomains']),
			"activedomains" => intval($vars['clientsstats']['numactivedomains']) . ' ('. intval($vars['clientsstats']['numdomains']) .')',
			"dueinvoices" => intval($vars['clientsstats']['numdueinvoices']),
			"overdueinvoices" => intval($vars['clientsstats']['numoverdueinvoices']),
			"activetickets" => intval($vars['clientsstats']['numactivetickets']),
			"creditbalance" => $vars['clientsstats']['creditbalance'],
			"shoppingcartitems" => intval($vars['cartitemcount']),
			"none" => "none",
			"" => "none"
		);
		
		
		$this->badges = $badges;
		
	}
    */
    
    /**
	 * Init Menu Badge From Context
	 */
	public function initMenuItemBadge(){
        
		$badges = array(
			"totalservices" => $this->getClientTotals('totalservices'),
			"activeservices" => $this->getClientTotals('activeservices') . ' ('. $this->getClientTotals('totalservices') .')',
			"totaldomains" => $this->getClientTotals('totaldomains'),
			"activedomains" => $this->getClientTotals('activedomains') . ' ('. $this->getClientTotals('totaldomains') .')',
			"dueinvoices" => $this->getClientTotals('dueinvoices'),
			"overdueinvoices" => $this->getClientTotals('overdueinvoices'),
			"activetickets" => $this->getClientTotals('activetickets'),
			"creditbalance" => $this->getClientTotals('creditbalance'),
			"shoppingcartitems" => $this->getClientTotals('shoppingcartitems'),
			"none" => "none",
			"" => "none"
		);
		
		$this->badges = $badges;
		
	}
    
    /*
    * Client Totals
    */
    public function getClientTotals($item){
        
        if ($this->clientTotals===null){
        
            $client = Menu::context("client");
            
            $services = json_decode($client->services, true);
            $domains = json_decode($client->domains, true);
            $invoices = json_decode($client->invoices, true);
            
            # Total Services
            $totalServices = 0;
            if (!is_null($client->services) && is_array($services)){
                $totalServices = count($services);
            }
            
            # Active Services
            $activeServices = 0;
            if (!is_null($client->services) && is_array($services)){
                foreach ($services as $service){
                    if ($service['domainstatus']=="Active"){
                        $activeServices++;
                    }
                }
            }
            
            # Total Domains
            $totalDomains = 0;
            if (!is_null($client->domains) && is_array($domains)){
                $totalDomains = count($domains);
            }
            
            # Active Domains
            $activeDomains = 0;
            if (!is_null($client->domains) && is_array($domains)){
                foreach ($domains as $domain){
                    if ($domain['status']=="Active"){
                        $activeDomains++;
                    }
                }
            }
            
            $today = date("Ymd");
            
            # Due Invoices
            $dueInvoices = 0;
            if (!is_null($client->invoices) && is_array($invoices)){
                foreach ($invoices as $invoice){
                    $dueDate = date("Ymd", strtotime($invoice['duedate']));
                    if ($invoice['status']=="Unpaid" && $today>=$dueDate){
                        $dueInvoices++;
                    }
                }
            }
            
            # Overdue Invoices
            $overdueInvoices = 0;
            if (!is_null($client->invoices) && is_array($invoices)){
                foreach ($invoices as $invoice){
                    $dueDate = date("Ymd", strtotime($invoice['duedate']));
                    if ($invoice['status']=="Unpaid" && $today>$dueDate){
                        $overdueInvoices++;
                    }
                }
            }
            
            # Active Tickets Statuses
            $getActiveTicketsStatus = Capsule::table("tblticketstatuses")
            ->where("showactive", "=", 1)
            ->select("title")
            ->get();
            $activeStatuses = array();
            foreach ($getActiveTicketsStatus as $status){
                $status = (array) $status;
                $activeStatuses[] = $status['title'];
            }
            
            # Get Active Tickets
            $getActiveTickets = Capsule::table("tbltickets")
            ->where("userid", "=", $client->id)
            ->whereIn("status", $activeStatuses)
            ->count();
            
            # Total Cart Items
            $totalCartItems = 0;
            if (is_array($_SESSION['cart']['products'])){
                $totalCartItems = $totalCartItems + count($_SESSION['cart']['products']);
            }
            if (is_array($_SESSION['cart']['domains'])){
                $totalCartItems = $totalCartItems + count($_SESSION['cart']['domains']);
            }
            
            # Get Client Currency
            $currencyData = getCurrency($client->id);
            $creditBalance = formatCurrency($client->credit, $currencyData);
            
            $this->clientTotals = array(
                "totalservices" => $totalServices,
                "activeservices" => $activeServices,
                "totaldomains" => $totalDomains,
                "activedomains" => $activeDomains,
                "dueinvoices" => $dueInvoices,
                "overdueinvoices" => $overdueInvoices,
                "activetickets" => $getActiveTickets,
                "creditbalance" => $creditBalance,
                "shoppingcartitems" => $totalCartItems
            );
        }
        
        return $this->clientTotals[ $item ];
        
    }
	
	/**
	 * Get Menu Badge
	 */
	public function getMenuItemBadge($badge){
		
		return $this->badges[$badge];
		
	}
    
    /**
     * Check if Menu Item is Active
     */
    public function isMenuItemActive($targetURL){
        
        $currentURL = "http://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
        
        $parseCurrentURL = parse_url($currentURL);
        
        $buildCurrentURL = str_replace("www.", "", $parseCurrentURL['host']);
        
        if ($parseCurrentURL['path']){
            $buildCurrentURL .= $parseCurrentURL['path'];
        }
        
        if ($parseCurrentURL['query']){
            $splitQueries = explode("&", str_replace("&amp;", "&", $parseCurrentURL['query']));
            
            if (is_array($splitQueries) &&count($splitQueries)>0){
                $buildCurrentURL .= '?';
            
                $queries = array();
                foreach ($splitQueries as $index => $value){
                    $splitValue = explode("=", $value);
                    if (in_array($splitValue[0], array("language", "systpl", "carttpl"))){
                        continue;
                    }
                    $queries[ $splitValue[0] ] = urldecode($splitValue[1]);
                }
                ksort($queries);
                $newQueries = array();
                foreach ($queries as $key => $value){
                    $newQueries[] = $key . "=" . $value;
                }
                $buildCurrentURL .= join("&", $newQueries);
            }
        }
        
        $currentURL = $buildCurrentURL;
        
        # Target URL
        $parseTargetURL = parse_url($targetURL);
        
        $buildTargetURL = str_replace("www.", "", $parseTargetURL['host']);
        
        if ($parseTargetURL['path']){
            $buildTargetURL .= $parseTargetURL['path'];
        }
        
        if ($parseTargetURL['query']){
            $splitQueries = explode("&", str_replace("&amp;", "&", $parseTargetURL['query']));
            
            if (is_array($splitQueries) &&count($splitQueries)>0){
                $buildTargetURL .= '?';
            
                $queries = array();
                foreach ($splitQueries as $index => $value){
                    $splitValue = explode("=", $value);
                    if (in_array($splitValue[0], array("language", "systpl", "carttpl"))){
                        continue;
                    }
                    $queries[ $splitValue[0] ] = urldecode($splitValue[1]);
                }
                ksort($queries);
                $newQueries = array();
                foreach ($queries as $key => $value){
                    $newQueries[] = $key . "=" . $value;
                }
                $buildTargetURL .= join("&", $newQueries);
            }
        }
        
        $targetURL = $buildTargetURL;
        
        return strcmp($currentURL, $targetURL);
        
    }
	
	/**
	 * Install WHMCS Primary Navbar
	 */
	public function installWHMCSPrimaryNavbar($groupid){
		
		global $CONFIG;
		
		$defaultLanguage = strtolower($CONFIG['Language']);
		
		# Get System Languages List
		$systemLanguages = $this->getWHMCSLanguages();
		
		# Get System Languages Loaded
		$Translations = [];
		foreach ($systemLanguages as $language){
		    unset($_LANG);
		    
		    if (is_file(ROOTDIR . "/lang/" . $language . ".php") === false){
		        continue;
		    }
		    
		    include(ROOTDIR . "/lang/" . $language . ".php");
		    
		    $Translations[ $language ] = $_LANG;
		    
		    if (is_file(ROOTDIR . "/lang/overrides/" . $language . ".php") === false){
		        continue;
		    }
		    
		    unset($_LANG);
		    
		    include(ROOTDIR . "/lang/overrides/" . $language . ".php");
		    
		    $Translations[ $language ] = array_replace($Translations[ $language ], $_LANG);
		    
		}
		
		# Get Default Language Loaded
		if (is_file(ROOTDIR . "/lang/" . $defaultLanguage . ".php") === true){
		    unset($_LANG);
		    include(ROOTDIR . "/lang/" . $defaultLanguage . ".php");
		    
		    $DefaultTranslation = $_LANG;
		    
		    unset($_LANG);
		    if (is_file(ROOTDIR . "/lang/overrides/" . $defaultLanguage . ".php") === true){
		        include(ROOTDIR . "/lang/overrides/" . $defaultLanguage . ".php");
		        
		        $DefaultTranslation = array_replace($DefaultTranslation, $_LANG);
		    }
		}
		
		# Get Product Groups
		$getProductGroups = Capsule::table("tblproductgroups")
		->where("hidden", "=", 0)
		->orderBy("order", "asc")
		->get();
		$productGroups = array();
		foreach ($getProductGroups as $group){
		    $group = (array) $group;
		    $productGroups[ $group['id'] ] = $group['name'];
		}
		
		# Home
		$menuItemHome = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['clientareanavhome'],
								"url" => "index.php",
								"urltype" => "clientarea-off",
								"reorder" => 0,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemHome,
		        "title" => (string) $translation['clientareanavhome'],
		        "language" => $language
		    ]);
		}
		
		# Home
		$menuItemHome = Capsule::table('menumanager_items')->insertGetId(
		    array(
		        "groupid" => $groupid,
		        "topid" => 0,
		        "parentid" => 0,
		        "title" => (string) $DefaultTranslation['clientareanavhome'],
		        "url" => "clientarea.php",
		        "urltype" => "clientarea-on",
		        "reorder" => 0,
		        "accesslevel" => 3,
		        "language" => $defaultLanguage,
		        "badge" => "none",
		        "datecreate" => date("Y-m-d H:i:s"),
		        "datemodify" => date("Y-m-d H:i:s")
		    )
		    );
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemHome,
		        "parentid" => 0,
		        "title" => (string) $translation['clientareanavhome'],
		        "language" => $language
		    ]);
		}
		
		# Store
		$menuItemStore = Capsule::table('menumanager_items')->insertGetId(
                		    array(
                		        "groupid" => $groupid,
                		        "topid" => 0,
                		        "parentid" => 0,
                		        "title" => (string) $DefaultTranslation['navStore'],
                		        "url" => "cart.php",
                		        "urltype" => "clientarea-off",
                		        "reorder" => 1,
                		        "accesslevel" => 1,
                		        "language" => $defaultLanguage,
                		        "badge" => "none",
                		        "datecreate" => date("Y-m-d H:i:s"),
                		        "datemodify" => date("Y-m-d H:i:s")
                		    )
		                );
        
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemStore,
		        "title" => (string) $translation['navStore'],
		        "language" => $language
		    ]);
		}
		
		    # Store Sub-Menu Items
        	$menuItemBrowseAll = Capsule::table('menumanager_items')->insertGetId(
        		    array(
        		        "groupid" => $groupid,
        		        "topid" => 0,
        		        "parentid" => $menuItemStore,
        		        "title" => (string) $DefaultTranslation['navBrowseProductsServices'],
        		        "url" => "cart.php",
        		        "urltype" => "clientarea-off",
        		        "reorder" => 1,
        		        "accesslevel" => 1,
        		        "language" => $defaultLanguage,
        		        "badge" => "none",
        		        "datecreate" => date("Y-m-d H:i:s"),
        		        "datemodify" => date("Y-m-d H:i:s")
        		    )
            );
        	
        	# Add Translations
        	foreach ($Translations as $language => $translation){
        	    Capsule::table("menumanager_items")
        	    ->insert([
        	        "groupid" => $groupid,
        	        "topid" => $menuItemBrowseAll,
        	        "parentid" => $menuItemStore,
        	        "title" => (string) $translation['navBrowseProductsServices'],
        	        "language" => $language
        	    ]);
        	}
        	
        	# Store Sub-Menu Items
        	Capsule::table('menumanager_items')->insert(
        	    array(
        	        "groupid" => $groupid,
        	        "topid" => 0,
        	        "parentid" => $menuItemStore,
        	        "title" => "-----",
        	        "url" => "#",
        	        "urltype" => "customurl",
        	        "reorder" => 2,
        	        "accesslevel" => 1,
        	        "language" => $defaultLanguage,
        	        "badge" => "none",
        	        "datecreate" => date("Y-m-d H:i:s"),
        	        "datemodify" => date("Y-m-d H:i:s")
        	    )
        	);
        	
        	/////////////////////////////////
        	# Add Product Groups As Menu Items
        	$storeSubMenuCounter = 3;
        	foreach ($productGroups as $groupID => $groupName){
        	    Capsule::table('menumanager_items')->insert(
        	        array(
        	            "groupid" => $groupid,
        	            "topid" => 0,
        	            "parentid" => $menuItemStore,
        	            "title" => (string) $groupName,
        	            "url" => "cart.php?gid=" . $groupID,
        	            "urltype" => "customurl",
        	            "reorder" => $storeSubMenuCounter,
        	            "accesslevel" => 1,
        	            "language" => $defaultLanguage,
        	            "badge" => "none",
        	            "datecreate" => date("Y-m-d H:i:s"),
        	            "datemodify" => date("Y-m-d H:i:s")
        	        )
        	    );
        	    
        	    $storeSubMenuCounter++;
        	}
        	/////////////////////////////////
		
        	# Register Domain
        	$menuItemRegisterDomain = Capsule::table('menumanager_items')->insertGetId(
        	    array(
        	        "groupid" => $groupid,
        	        "topid" => 0,
        	        "parentid" => $menuItemStore,
        	        "title" => (string) $DefaultTranslation['navregisterdomain'],
        	        "url" => "cart.php?a=add&domain=register",
        	        "urltype" => "clientarea-off",
        	        "reorder" => $storeSubMenuCounter+1,
        	        "accesslevel" => 1,
        	        "language" => $defaultLanguage,
        	        "badge" => "none",
        	        "datecreate" => date("Y-m-d H:i:s"),
        	        "datemodify" => date("Y-m-d H:i:s")
        	    )
        	);
        	
        	# Add Translations
        	foreach ($Translations as $language => $translation){
        	    Capsule::table("menumanager_items")
        	    ->insert([
        	        "groupid" => $groupid,
        	        "topid" => $menuItemRegisterDomain,
        	        "parentid" => $menuItemStore,
        	        "title" => (string) $translation['navregisterdomain'],
        	        "language" => $language
        	    ]);
        	}
        	
        	# Transfer Domain
        	$menuItemTransferDomain = Capsule::table('menumanager_items')->insertGetId(
        	    array(
        	        "groupid" => $groupid,
        	        "topid" => 0,
        	        "parentid" => $menuItemStore,
        	        "title" => (string) $DefaultTranslation['navtransferdomain'],
        	        "url" => "cart.php?a=add&domain=transfer",
        	        "urltype" => "clientarea-off",
        	        "reorder" => $storeSubMenuCounter+2,
        	        "accesslevel" => 1,
        	        "language" => $defaultLanguage,
        	        "badge" => "none",
        	        "datecreate" => date("Y-m-d H:i:s"),
        	        "datemodify" => date("Y-m-d H:i:s")
        	    )
        	);
        	
        	# Add Translations
        	foreach ($Translations as $language => $translation){
        	    Capsule::table("menumanager_items")
        	    ->insert([
        	        "groupid" => $groupid,
        	        "topid" => $menuItemTransferDomain,
        	        "parentid" => $menuItemStore,
        	        "title" => (string) $translation['navtransferdomain'],
        	        "language" => $language
        	    ]);
        	}
        	
		# Announcements
		$menuItemAnnouncements = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['announcementstitle'],
								"url" => "announcements.php",
								"urltype" => "clientarea-off",
								"reorder" => 2,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemAnnouncements,
		        "parentid" => 0,
		        "title" => (string) $translation['announcementstitle'],
		        "language" => $language
		    ]);
		}
		
		# Knowledgebase
		$menuItemKB = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['knowledgebasetitle'],
								"url" => "knowledgebase.php",
								"urltype" => "clientarea-off",
								"reorder" => 3,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemKB,
		        "parentid" => 0,
		        "title" => (string) $translation['knowledgebasetitle'],
		        "language" => $language
		    ]);
		}
		
		# Network Status
		$menuItemNetworkStatus = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['networkstatustitle'],
								"url" => "serverstatus.php",
								"urltype" => "clientarea-on",
								"reorder" => 4,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemNetworkStatus,
		        "parentid" => 0,
		        "title" => (string) $translation['networkstatustitle'],
		        "language" => $language
		    ]);
		}
		
		# Contact Us
		$menuItemContact = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['contactus'],
								"url" => "contact.php",
								"urltype" => "clientarea-off",
								"reorder" => 5,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemContact,
		        "parentid" => 0,
		        "title" => (string) $translation['contactus'],
		        "language" => $language
		    ]);
		}
		
		######## Now Menu Of Clients
		
		# Services
		$menuItemServices = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['navservices'],
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 7,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
    		# Add Translations
    		foreach ($Translations as $language => $translation){
    		    Capsule::table("menumanager_items")
    		    ->insert([
    		        "groupid" => $groupid,
    		        "topid" => $menuItemServices,
    		        "parentid" => 0,
    		        "title" => (string) $translation['navservices'],
    		        "language" => $language
    		    ]);
    		}
		    
		    # My Services
			$menuItemMyServices = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemServices,
							    "title" => (string) $DefaultTranslation['clientareanavservices'],
								"url" => "clientarea.php?action=products",
								"urltype" => "clientarea-on",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMyServices,
			        "parentid" => $menuItemServices,
			        "title" => (string) $translation['clientareanavservices'],
			        "language" => $language
			    ]);
			}
			
			
            # My Projects
			$menuItemMyProjects = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemServices,
							    "title" => (string) $DefaultTranslation['clientareaprojects'],
								"url" => "index.php?m=project_management",
								"urltype" => "customurl",
								"reorder" => 2,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMyProjects,
			        "parentid" => $menuItemServices,
			        "title" => (string) $translation['clientareaprojects'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemServices,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Order New Service
			$menuItemNewOrder = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemServices,
							    "title" => (string) $DefaultTranslation['navservicesorder'],
								"url" => "cart.php",
								"urltype" => "clientarea-off",
								"reorder" => 4,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemNewOrder,
			        "parentid" => $menuItemServices,
			        "title" => (string) $translation['navservicesorder'],
			        "language" => $language
			    ]);
			}
			
			# View Available Addons
			$menuItemAddonsAvailable = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemServices,
							    "title" => (string) $DefaultTranslation['clientareaviewaddons'],
								"url" => "cart.php?gid=addons",
								"urltype" => "clientarea-on",
								"reorder" => 5,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemAddonsAvailable,
			        "parentid" => $menuItemServices,
			        "title" => (string) $translation['clientareaviewaddons'],
			        "language" => $language
			    ]);
			}
		
		# Domains
		$menuItemDomains = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['navdomains'],
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 8,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
        
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemDomains,
		        "parentid" => 0,
		        "title" => (string) $translation['navdomains'],
		        "language" => $language
		    ]);
		}
			
		    
		    # My Domains
			$menuItemMyDomains = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
							    "title" => (string) $DefaultTranslation['clientareanavdomains'],
								"url" => "clientarea.php?action=domains",
								"urltype" => "clientarea-on",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMyDomains,
			        "parentid" => $menuItemDomains,
			        "title" => (string) $translation['clientareanavdomains'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 2,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			
			# Renew Domains
			$menuItemRenewDomains = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
							    "title" => (string) $DefaultTranslation['navrenewdomains'],
								"url" => "cart.php?gid=renewals",
								"urltype" => "clientarea-on",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemRenewDomains,
			        "parentid" => $menuItemDomains,
			        "title" => (string) $translation['navrenewdomains'],
			        "language" => $language
			    ]);
			}
			
			# Register a New Domain
			$menuItemRegisterDomain = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
							    "title" => (string) $DefaultTranslation['navregisterdomain'],
								"url" => "cart.php?a=add&domain=register",
								"urltype" => "clientarea-off",
								"reorder" => 4,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemRegisterDomain,
			        "parentid" => $menuItemDomains,
			        "title" => (string) $translation['navregisterdomain'],
			        "language" => $language
			    ]);
			}
			
			# Transfer Domains to Us
			$menuItemTransferDomain = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
							    "title" => (string) $DefaultTranslation['navtransferdomain'],
								"url" => "cart.php?a=add&domain=transfer",
								"urltype" => "clientarea-off",
								"reorder" => 5,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemTransferDomain,
			        "parentid" => $menuItemDomains,
			        "title" => (string) $translation['navtransferdomain'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 6,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Domain Search
			$menuItemDomainSearch = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemDomains,
							    "title" => (string) $DefaultTranslation['navdomainsearch'],
								"url" => "domainchecker.php",
								"urltype" => "clientarea-off",
								"reorder" => 7,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		    
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemDomainSearch,
			        "parentid" => $menuItemDomains,
			        "title" => (string) $translation['navdomainsearch'],
			        "language" => $language
			    ]);
			}
			
		# Billing
		$menuItemBilling = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['navbilling'],
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 9,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemBilling,
		        "parentid" => 0,
		        "title" => (string) $translation['navbilling'],
		        "language" => $language
		    ]);
		}
		    
			# My Invoices
			$menuItemMyInvoices = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
							    "title" => (string) $DefaultTranslation['invoices'],
								"url" => "clientarea.php?action=invoices",
								"urltype" => "clientarea-on",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMyInvoices,
			        "parentid" => $menuItemBilling,
			        "title" => (string) $translation['invoices'],
			        "language" => $language
			    ]);
			}
			
			# My Quotes
			$menuItemMyQuotes = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
							    "title" => (string) $DefaultTranslation['quotestitle'],
								"url" => "clientarea.php?action=quotes",
								"urltype" => "clientarea-on",
								"reorder" => 2,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMyQuotes,
			        "parentid" => $menuItemBilling,
			        "title" => (string) $translation['quotestitle'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Funds
			$menuItemAddFunds = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
							    "title" => (string) $DefaultTranslation['addfunds'],
								"url" => "clientarea.php?action=addfunds",
								"urltype" => "clientarea-on",
								"reorder" => 4,
								"accesslevel" => 9,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemAddFunds,
			        "parentid" => $menuItemBilling,
			        "title" => (string) $translation['addfunds'],
			        "language" => $language
			    ]);
			}
			
			# Mass Payment
			$menuItemMassPayment = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
							    "title" => (string) $DefaultTranslation['masspaytitle'],
								"url" => "clientarea.php?action=masspay&all=true",
								"urltype" => "clientarea-on",
								"reorder" => 5,
								"accesslevel" => 10,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemMassPayment,
			        "parentid" => $menuItemBilling,
			        "title" => (string) $translation['masspaytitle'],
			        "language" => $language
			    ]);
			}
			
			# Manage Credit Card
			$menuItemCreditCard = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemBilling,
							    "title" => (string) $DefaultTranslation['navmanagecc'],
								"url" => "clientarea.php?action=creditcard",
								"urltype" => "clientarea-on",
								"reorder" => 6,
								"accesslevel" => 8,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemCreditCard,
			        "parentid" => $menuItemBilling,
			        "title" => (string) $translation['navmanagecc'],
			        "language" => $language
			    ]);
			}
		
		# Support
		$menuItemSupport = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['navsupport'],
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 10,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemSupport,
		        "parentid" => 0,
		        "title" => (string) $translation['navsupport'],
		        "language" => $language
		    ]);
		}
		    
			# Tickets
			$menuItemTickets = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemSupport,
							    "title" => (string) $DefaultTranslation['navtickets'],
								"url" => "supporttickets.php",
								"urltype" => "clientarea-on",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemTickets,
			        "parentid" => $menuItemSupport,
			        "title" => (string) $translation['navtickets'],
			        "language" => $language
			    ]);
			}
			
			# Announcements
			$menuItemAnnouncements = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemSupport,
							    "title" => (string) $DefaultTranslation['announcementstitle'],
								"url" => "announcements.php",
								"urltype" => "clientarea-off",
								"reorder" => 2,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemAnnouncements,
			        "parentid" => $menuItemSupport,
			        "title" => (string) $translation['announcementstitle'],
			        "language" => $language
			    ]);
			}
			
			# Knowledgebase
			$menuItemKB = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemSupport,
							    "title" => (string) $DefaultTranslation['knowledgebasetitle'],
								"url" => "knowledgebase.php",
								"urltype" => "clientarea-off",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemKB,
			        "parentid" => $menuItemSupport,
			        "title" => (string) $translation['knowledgebasetitle'],
			        "language" => $language
			    ]);
			}
			
			# Downloads
			$menuItemDownloads = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemSupport,
							    "title" => (string) $DefaultTranslation['downloadstitle'],
								"url" => "downloads.php",
								"urltype" => "clientarea-off",
								"reorder" => 4,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemDownloads,
			        "parentid" => $menuItemSupport,
			        "title" => (string) $translation['downloadstitle'],
			        "language" => $language
			    ]);
			}
			
			# Network Status
			$menuItemNetwork = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemSupport,
							    "title" => (string) $DefaultTranslation['networkstatustitle'],
								"url" => "serverstatus.php",
								"urltype" => "clientarea-on",
								"reorder" => 5,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemNetwork,
			        "parentid" => $menuItemSupport,
			        "title" => (string) $translation['networkstatustitle'],
			        "language" => $language
			    ]);
			}
		
		# Open Ticket
		$menuItemOpenTicket = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['navopenticket'],
								"url" => "submitticket.php",
								"urltype" => "clientarea-off",
								"reorder" => 11,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemOpenTicket,
		        "parentid" => $menuItemSupport,
		        "title" => (string) $translation['navopenticket'],
		        "language" => $language
		    ]);
		}
		
		
		# Affiliates
		$menuItemAffiliates = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['affiliatestitle'],
								"url" => "affiliates.php",
								"urltype" => "clientarea-on",
								"reorder" => 12,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemAffiliates,
		        "parentid" => 0,
		        "title" => (string) $translation['affiliatestitle'],
		        "language" => $language
		    ]);
		}
		
	}
	
	/**
	 * Install WHMCS Secondary Navbar
	 */
	public function installWHMCSSecondaryNavbar($groupid){
		
		global $CONFIG;
		
		$defaultLanguage = strtolower($CONFIG['Language']);
		
		# Get System Languages List
		$systemLanguages = $this->getWHMCSLanguages();
		
		# Get System Languages Loaded
		$Translations = [];
		foreach ($systemLanguages as $language){
		    unset($_LANG);
		    
		    if (is_file(ROOTDIR . "/lang/" . $language . ".php") === false){
		        continue;
		    }
		    
		    include(ROOTDIR . "/lang/" . $language . ".php");
		    
		    $Translations[ $language ] = $_LANG;
		    
		    if (is_file(ROOTDIR . "/lang/overrides/" . $language . ".php") === false){
		        continue;
		    }
		    
		    unset($_LANG);
		    
		    include(ROOTDIR . "/lang/overrides/" . $language . ".php");
		    
		    $Translations[ $language ] = array_replace($Translations[ $language ], $_LANG);
		    
		}
		
		# Get Default Language Loaded
		if (is_file(ROOTDIR . "/lang/" . $defaultLanguage . ".php") === true){
		    unset($_LANG);
		    include(ROOTDIR . "/lang/" . $defaultLanguage . ".php");
		    
		    $DefaultTranslation = $_LANG;
		    
		    unset($_LANG);
		    if (is_file(ROOTDIR . "/lang/overrides/" . $defaultLanguage . ".php") === true){
		        include(ROOTDIR . "/lang/overrides/" . $defaultLanguage . ".php");
		        
		        $DefaultTranslation = array_replace($DefaultTranslation, $_LANG);
		    }
		}
		
		# Visitors Menu
		$menuItemAccount = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) $DefaultTranslation['account'],
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 1,
								"accesslevel" => 2,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		    
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemAccount,
		        "parentid" => 0,
		        "title" => (string) $translation['account'],
		        "language" => $language
		    ]);
		}
		    
			# Login
			$menuItemLogin = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['login'],
								"url" => "login.php",
								"urltype" => "clientarea-off",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemLogin,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['login'],
			        "language" => $language
			    ]);
			}
			
						
			# Register
			$menuItemRegister = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['register'],
								"url" => "register.php",
								"urltype" => "clientarea-off",
								"reorder" => 2,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemRegister,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['register'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			
			
			# Forgot Password
			$menuItemReset = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['forgotpw'],
								"url" => "pwreset.php",
								"urltype" => "clientarea-off",
								"reorder" => 4,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemReset,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['forgotpw'],
			        "language" => $language
			    ]);
			}
			
		
		# Clients Menu
		$menuItemAccount = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => 0,
							    "title" => (string) sprintf($DefaultTranslation['helloname'], '{$clientfirstname}'),
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 2,
								"accesslevel" => 3,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
		
		# Add Translations
		foreach ($Translations as $language => $translation){
		    Capsule::table("menumanager_items")
		    ->insert([
		        "groupid" => $groupid,
		        "topid" => $menuItemAccount,
		        "parentid" => 0,
		        "title" => (string) sprintf($translation['helloname'], '{$clientfirstname}'),
		        "language" => $language
		    ]);
		}
		
		
			# Edit Account Details
			$menuItemAccountDetails = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['editaccountdetails'],
								"url" => "clientarea.php?action=details",
								"urltype" => "clientarea-on",
								"reorder" => 1,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemAccountDetails,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['editaccountdetails'],
			        "language" => $language
			    ]);
			}
			
			# Manage Credit Card
			$menuItemManageCC = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['navmanagecc'],
								"url" => "clientarea.php?action=creditcard",
								"urltype" => "clientarea-on",
								"reorder" => 2,
								"accesslevel" => 8,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemManageCC,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['navmanagecc'],
			        "language" => $language
			    ]);
			}
			
			# Contacts
			$menuItemContacts = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['clientareanavcontacts'],
								"url" => "clientarea.php?action=contacts",
								"urltype" => "clientarea-on",
								"reorder" => 3,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemContacts,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['affiliatestitle'],
			        "language" => $language
			    ]);
			}
			
			# Add Funds
			$menuItemAddFunds = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['addfunds'],
								"url" => "clientarea.php?action=addfunds",
								"urltype" => "clientarea-on",
								"reorder" => 4,
								"accesslevel" => 9,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemAddFunds,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['addfunds'],
			        "language" => $language
			    ]);
			}
			
			
			# Email History
			$menuItemEmailHistory = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['navemailssent'],
								"url" => "clientarea.php?action=emails",
								"urltype" => "clientarea-on",
								"reorder" => 5,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemEmailHistory,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['navemailssent'],
			        "language" => $language
			    ]);
			}
			
			# Change Password
			$menuItemChange = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['clientareanavchangepw'],
								"url" => "clientarea.php?action=changepw",
								"urltype" => "clientarea-on",
								"reorder" => 6,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemChange,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['clientareanavchangepw'],
			        "language" => $language
			    ]);
			}
			
			# Divider
			Capsule::table('menumanager_items')->insert(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
								"title" => "-----",
								"url" => "#",
								"urltype" => "customurl",
								"reorder" => 7,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Logout
			$menuItemLogout = Capsule::table('menumanager_items')->insertGetId(
							array(
								"groupid" => $groupid,
								"topid" => 0,
								"parentid" => $menuItemAccount,
							    "title" => (string) $DefaultTranslation['clientareanavlogout'],
								"url" => "logout.php",
								"urltype" => "clientarea-on",
								"reorder" => 8,
								"accesslevel" => 1,
								"language" => $defaultLanguage,
								"badge" => "none",
								"datecreate" => date("Y-m-d H:i:s"),
								"datemodify" => date("Y-m-d H:i:s")
							)
						);
			
			# Add Translations
			foreach ($Translations as $language => $translation){
			    Capsule::table("menumanager_items")
			    ->insert([
			        "groupid" => $groupid,
			        "topid" => $menuItemLogout,
			        "parentid" => $menuItemAccount,
			        "title" => (string) $translation['affiliatestitle'],
			        "language" => $language
			    ]);
			}
			
	}
}

}
?>