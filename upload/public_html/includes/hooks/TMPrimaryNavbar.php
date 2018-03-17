<?php

	$ca = new WHMCS_ClientArea();
	use WHMCS\View\Menu\Item as MenuItem;
	use Illuminate\Database\Capsule\Manager as Capsule;

	
	add_hook('ClientAreaPrimaryNavbar', 1, function (MenuItem $primaryNavbar)
	{
			global $CONFIG;			
			$friendlyurl = $CONFIG['RouteUriPathMode'];
    
			if ($friendlyurl == 'acceptpathinfo') {
				$urlpath = 'index.php/store/';
			}
			elseif ($friendlyurl == 'rewrite') {
				$urlpath = 'store/';
			}
			elseif ($friendlyurl == 'basic') {
				$urlpath = 'index.php?rp=/store/';
			}
				
			$marketconnect = Capsule::table('tblmarketconnect_services')->where('status', '1')->get();
			
			
			$client = Menu::context('client');
								
				// Navbar Items for Clients
				
				
				if (!is_null($primaryNavbar->removeChild('Affiliates'))) {}
				if (!is_null($primaryNavbar->removeChild('Open Ticket'))) {}
				if (!is_null($primaryNavbar->removeChild('Store'))) {}
				if (!is_null($primaryNavbar->removeChild('Website Security'))) {}

				
				// Moved custom pages in services child menu 
				if (!is_null($primaryNavbar->getChild('Services'))) {
					
					$primaryNavbar->getChild('Services')
						->removeChild('Order New Services');

						
					if (count($marketconnect)) {
						foreach ($marketconnect as $service) {
							if ($service->name == 'symantec') {
								
								$primaryNavbar->getChild('Services')
									->addChild('Manage SSL Certificates', array(
									'label' => Lang::trans('navManageSsl'),
									'uri' => $urlpath.'ssl-certificates/manage',
									'order' => '20',
								));
							}
						}
					}

							
					$primaryNavbar->getChild('Services')
						->addChild('Shared Hosting', array(
						'uri' => 'web-hosting.php',
						'order' => '60',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('Reseller Hosting', array(
						'uri' => 'reseller-hosting.php',
						'order' => '70',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('VPS Hosting', array(
						'uri' => 'vps-hosting.php',
						'order' => '80',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('Dedicated Servers', array(
						'uri' => 'dedicated-servers.php',
						'order' => '90',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('SSL Certificates', array(
						'label' => Lang::trans('navMarketConnectService.symantec'),
						'uri' => 'ssl-certificates.php',
						'order' => '100',
					));
					
					if (count($marketconnect)) {
						foreach ($marketconnect as $service) {
							if ($service->name == 'symantec') {
								
								$primaryNavbar->getChild('Services')
									->addChild('SSL Certificates', array(
									'label' => Lang::trans('navMarketConnectService.symantec'),
									'uri' => $urlpath.'ssl-certificates',
									'order' => '100',
								));
								
							} elseif ($service->name == 'weebly') {
						
								$primaryNavbar->getChild('Services')
									->addChild('Website Builder', array(
									'label' => Lang::trans('navMarketConnectService.weebly'),
									'uri' => $urlpath.'website-builder',
									'order' => '110',
								));
								
							} if ($service->name == 'spamexperts') {

								$primaryNavbar->getChild('Services')
									->addChild('E-mail Services', array(
									'label' => Lang::trans('navMarketConnectService.spamexperts'),
									'uri' => $urlpath.'email-services',
									'order' => '120',
								));
							}
					
					
						}
					}
					
					
				}
				//Moved Affiliate links to under Billing child menu 
				if (!is_null($primaryNavbar->getChild('Billing'))) {
					
					$primaryNavbar->getChild('Billing')
						->addChild('Affiliates', array(
						'label' => Lang::trans('affiliatestitle'),
						'uri' => 'affiliates.php',
						'order' => '70',
					));
				}
				
				//Moved Open Ticket links to under Support child menu 
				if (!is_null($primaryNavbar->getChild('Support'))) {
					
					$primaryNavbar->getChild('Support')
						->addChild('Open Ticket', array(
						'label' => Lang::trans('navopenticket'),
						'uri' => 'submitticket.php',
						'order' => '10',
					));				
					
					$primaryNavbar->getChild('Support')
						->addChild('Contact Us', array(
						'label' => Lang::trans('contactus'),
						'uri' => 'contact.php',
						'order' => '70',
					));
					
				}
					
				// Custom About Us menu rearrange order for clients
				if (!is_null($primaryNavbar->addChild('About Us'))) {
					$navItem = $primaryNavbar->getChild('About Us');
					if (is_null($navItem)) {
						return;
					} 
					
					$navItem->setOrder(40);
					$navItem->setUri('about-us.php');
				}
			
				
				
			if (is_null($client)) {
				
				
				// Navbar Items for visitors
				
				
				if (!is_null($primaryNavbar->removeChild('Announcements'))) {}
				if (!is_null($primaryNavbar->removeChild('Network Status'))) {}
				if (!is_null($primaryNavbar->removeChild('Knowledgebase'))) {}
				
				
					
				// Custom Servers menu for logout clients				
				if (!is_null($primaryNavbar->addChild('Services'))) {
					$navItem = $primaryNavbar->getChild('Services');
					if (is_null($navItem)) {
						return;
					} 	$navItem->setOrder(20);
						$navItem->setLabel(Lang::trans('navservices'));
				
					$primaryNavbar->getChild('Services')
						->addChild('Shared Hosting', array(
						'uri' => 'web-hosting.php',
						'order' => '10',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('Reseller Hosting', array(
						'uri' => 'reseller-hosting.php',
						'order' => '20',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('VPS Hosting', array(
						'uri' => 'vps-hosting.php',
						'order' => '30',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('Dedicated Servers', array(
						'uri' => 'dedicated-servers.php',
						'order' => '40',
					));
					
					$primaryNavbar->getChild('Services')
						->addChild('SSL Certificates', array(
						'label' => Lang::trans('navMarketConnectService.symantec'),
						'uri' => 'ssl-certificates.php',
						'order' => '50',
					));
					
					if (count($marketconnect)) {
						foreach ($marketconnect as $service) {
							if ($service->name == 'symantec') {
								
								$primaryNavbar->getChild('Services')
									->addChild('SSL Certificates', array(
									'label' => Lang::trans('navMarketConnectService.symantec'),
									'uri' => $urlpath.'ssl-certificates',
									'order' => '50',
								));
								
							} elseif ($service->name == 'weebly') {
						
								$primaryNavbar->getChild('Services')
									->addChild('Website Builder', array(
									'label' => Lang::trans('navMarketConnectService.weebly'),
									'uri' => $urlpath.'website-builder',
									'order' => '60',
								));
								
							} if ($service->name == 'spamexperts') {

								$primaryNavbar->getChild('Services')
									->addChild('E-mail Services', array(
									'label' => Lang::trans('navMarketConnectService.spamexperts'),
									'uri' => $urlpath.'email-services',
									'order' => '70',
								));
							}
					
					
						}
					}
				}
				
				
				//Custom support menu
				if (!is_null($primaryNavbar->addChild('Support'))) {
					$navItem = $primaryNavbar->getChild('Support');
					if (is_null($navItem)) {
					return;
					} 	
					
					$navItem->setOrder(20);
					$navItem->setLabel(Lang::trans('navsupport'));

					$primaryNavbar->getChild('Support')
						->addChild('Tickets', array(
						'label' => Lang::trans('navtickets'),
						'uri' => 'supporttickets.php',
						'order' => '10',
					));

					$primaryNavbar->getChild('Support')
						->addChild('Knowledgebase', array(
						'label' => Lang::trans('knowledgebasetitle'),
						'uri' => 'knowledgebase.php',
						'order' => '20',
					));

					$primaryNavbar->getChild('Support')
						->addChild('Announcements', array(
						'label' => Lang::trans('announcementstitle'),
						'uri' => 'announcements.php',
						'order' => '30',
					));
					
					$primaryNavbar->getChild('Support')
						->addChild('Network Status', array(
						'label' => Lang::trans('networkstatustitle'),
						'uri' => 'serverstatus.php',
						'order' => '40',
					));
					

					
				}
				
				// Custom About Us menu rearrange order for visitors		
				$navItem = $primaryNavbar->getChild('About Us');
					if (is_null($navItem)) {
						return;
					}
				$navItem->setOrder(30);
				
			}

				
	});
?>