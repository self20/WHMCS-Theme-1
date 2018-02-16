{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}		
					{if !$showingLoginPage}
					{if $templatefile eq 'homepage' or $pagetype eq 'redo' or $carttpl eq 'redo-default' or $carttpl eq 'redo-default-rtl' or $skipMainBodyContainer}{else}
			
			
			
					</div>
					{if !$inShoppingCart && $secondarySidebar->hasChildren()}
						<div class="col-md-3 pull-md-left" style="clear: right;">
							{include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
						</div>
					{/if}
				</div>
	
				<div class="clearfix"></div>
    
			
			
			</div>
		</div>
		{/if}
		
		<div class="block-s6 {if $templatefile == "products"}white{else}light{/if}">
			<div class="container-fluid">
				<div class="space-10"></div>
				<div class="owl-carousel partners-slider">
					<!-- Wrapper for partners slides --> 
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_1.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_2.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_3.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_4.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_5.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_6.png" alt="" class="center-block img-responsive">
					</div>
					<div class="item">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/gallery/client_7.png" alt="" class="center-block img-responsive">
					</div>
					<!-- /Wrapper for slides -->
				</div>
			</div>
		</div>	
		
		<div class="block-breadcrumbs">
			<div class="container-fluid">
				<ol class="breadcrumb">
					<li><i class="fa fa-map-marker text-primary"></i></li>
					<li>{$breadcrumbnav}</li>
				</ol>
			
			</div>
		</div>

		<!--Footer-->
		<div class="block-footer">
			<div class="footer-widgets">
				<div class="container-fluid">
				<div class="row">
					<div class="col-md-15 col-sm-3">
						<div data-toggle="collapse" data-target="#ServicesMenuList">
							<h4>{$LANG.navservices} <span class="pull-right"><i class="fa fa-angle-right"></i></span></h4>
						</div>
						
						<ul id="ServicesMenuList" class="list-unstyled collapse">
							<li><a href="{$WEB_ROOT}/web-hosting.php">Web Hosting</a></li>
							<li><a href="{$WEB_ROOT}/reseller-hosting.php">Reseller Hosting</a></li>
							<li><a href="{$WEB_ROOT}/vps-hosting.php">VPS Hosting</a></li>
							<li><a href="{$WEB_ROOT}/dedicated-servers.php">Dedicated Servers</a></li>
						</ul>
					</div>
					
					<div class="col-md-15 col-sm-3">
						<div data-toggle="collapse" data-target="#DomainsMenuList">
							<h4>{$LANG.navdomains} <span class="pull-right"><i class="fa fa-angle-right"></i></span></h4>
						</div>
						<ul id="DomainsMenuList" class="list-unstyled collapse">
							<li><a href="{$WEB_ROOT}/domainchecker.php">{$LANG.navdomainsearch}</a></li>
							<li><a href="{$WEB_ROOT}/cart.php?a=add&domain=transfer">{$LANG.transferdomain}</a></li>
							{if $bulkdomainsearchenabled}<li><a href="{$WEB_ROOT}/domainchecker.php?search=bulk">Bulk Domains</a></li>{/if}
						</ul>
					</div>
					
					<div class="col-md-15 col-sm-3">
						<div data-toggle="collapse" data-target="#CompanyMenuList">
							<h4>Company <span class="pull-right"><i class="fa fa-angle-right"></i></span></h4>
						</div>
						<ul id="CompanyMenuList" class="list-unstyled collapse">
							<li><a href="{$WEB_ROOT}/about-us.php">About Us</a></li>
							<li><a href="#">Our History</a></li>
							<li><a href="#">Our Awards</a></li>
							<li><a href="{$WEB_ROOT}/affiliates.php">{$LANG.affiliatestitle}</a></li>
						</ul>
					</div>
					
					<div class="col-md-15 col-sm-3">
						<div data-toggle="collapse" data-target="#SupportMenuList">
							<h4>{$LANG.navsupport} <span class="pull-right"><i class="fa fa-angle-right"></i></span></h4>
						</div>
						<ul id="SupportMenuList" class="list-unstyled collapse">
							<li><a href="{$WEB_ROOT}/submitticket.php">{$LANG.navopenticket}</a></li>
							<li><a href="{$WEB_ROOT}/serverstatus.php">{$LANG.networkstatustitle}</a></li>
							<li><a href="{$WEB_ROOT}/knowledgebase.php">{$LANG.knowledgebasetitle}</a></li>
							<li><a href="{$WEB_ROOT}/downloads.php">{$LANG.downloadstitle}</a></li>
						</ul>				
					</div>					

					<div class="col-md-15 col-sm-3 hidden-sm hidden-xs social">
						<h4>Follow Us</h4>
						<ul class="list-inline">
							<li><a href="#" class="btn btn-facebook"><i class="fa fa-facebook icon-only"></i></a></li>
							<li><a href="#" class="btn btn-googleplus"><i class="fa fa-google-plus icon-only"></i></a></li>
							<li><a href="#" class="btn btn-twitter"><i class="fa fa-twitter icon-only"></i></a></li>
							<li><a href="#" class="btn btn-linkedin"><i class="fa fa-linkedin icon-only"></i></a></li>
						</ul>
						
						
						<p class="bigger-130"><i class="fa fa-phone"></i> (123) 456-7890</p>
						
					</div>
				</div>
					
				</div>
			</div>
			
			<div class="footer-additional-menu">
				<div class="container-fluid">
					<div class="footer-menu-wrapper">
						<ul>
						   <li><a href="#">Privacy Policy</a></li>
							<li><a href="#">Terms of Use</a></li>
							<li><a href="#">SLA Aggrement</a></li>
						 </ul>
					</div>
				</div>
			</div>

			<div class="footer-copyright">
				<div class="container">
				   <p>{$LANG.copyright} &copy; {$date_year} {$companyname}. <span class="hidden-xs">{$LANG.allrightsreserved}.</span></p>
				</div>
			</div>
			
		</div>
		<!-- //Footer -->
		
		<a id="back-to-top" href="" class="btn btn-primary btn-line back-to-top" role="button"><i class="fa fa-angle-double-up icon-only bigger-110"></i></a>
		<!--End Footer-->
		
		<!-- Modal for search-->
		<div class="modal fade search-model" id="Redo-search-box" tabindex="-1" role="dialog" aria-labelledby="Redo-search-box" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">					
					<div class="modal-body">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
						<form method="post" action="{$WEB_ROOT}/knowledgebase.php?action=search">
							<input type="text" name="search" class="form-control input-lg" placeholder="{$LANG.search} ..." />
						</form>
					</div>
				</div>
			</div>
		</div>		

		
	</div><!-- /page container -->
	
	<!-- basic scripts -->
		<script src="{$WEB_ROOT}/templates/{$template}/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
		<script src="{$WEB_ROOT}/templates/{$template}/assets/js/plugins/pace/pace.min.js"></script>
		<script type="text/javascript" src="{$WEB_ROOT}/templates/{$template}/assets/js/plugins/owl-carousel/owl.carousel.min.js"></script>
		<script src="{$WEB_ROOT}/templates/{$template}/assets/js/plugins/footable/footable.min.js"></script>		
		
		<script src="{$WEB_ROOT}/templates/{$template}/assets/js/main.min.js"></script>
		<script src="{$WEB_ROOT}/templates/{$template}/assets/js/plugins/footable/footable.init.js"></script>
		
		<script type="text/javascript">
			// init variables require for top navigation bar
				Apps.initNavTopBar();
			// end

			$(function () {
				$('#langScroll, #taskScroll').slimScroll({
					height: '190px',
					disableFadeOut: true,
					touchScrollStep: 50
				});
			});
			
			{if $pagetype eq 'redo' or $templatefile eq 'homepage'}
			
				$("#Redo-Slider-home").owlCarousel({
					loop: true,
					autoplay:true,
					autoplayHoverPause:true,
					items: 1,
					rtl: true
			
				});	
			
			
				{if $templatefile == 'about-us'}
			
				$(".team-slider").owlCarousel({
					rtl: true,
					responsive:{
						0:{
							items:1,
						},					
						450:{
							items:2,
						},
						768:{
							items:3,
						},
						992:{
							items:4,
						},
						1200:{
							items:5,
						}
					}
				});
			
				{/if}
			

				$(".pricing-slider").owlCarousel({
					rtl: true,
					responsive:{
						0:{
							items:1,
						},
						768:{
							items:2,
						},
						992:{
							items:3,
						},
						1200:{
							items:4,
						}
					}
				});
			
				$(".features-slider").owlCarousel({ 
					rtl: true,
					responsive:{
						0:{
							items:1,
						},
						768:{
							items:2,
						},
						992:{
							items:3,
						},
						1200:{
							items:4,
						}
					}
				});
			
			{/if}
			
			$(".partners-slider").owlCarousel({
				loop: true,			
				autoplay:true,
				dots: false,
				rtl: true,
				responsive:{
					0:{
						items:1,
					},
					450:{
						items:2,
					},
					768:{
						items:3,
					},
					992:{
						items:4,
					},
					1200:{
						items:5,
					}
				}
			});
			
			{if $skipMainBodyContainer}
				$('.landing-page').addClass('mass-head');
				$('.landing-page .hero').addClass('hero-bg-wrap style-2 bg-opacity inverse');
				$('.landing-page .container').addClass('page-title');
			{/if}
			
			$("p:contains('Powered by')").remove();
			
		</script>

		
		<div class="modal system-modal fade modal-scroll" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content panel panel-primary">
					<div class="modal-header panel-heading bg-primary">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">Title</h4>
					</div>
					<div class="modal-body panel-body">
						Loading...
					</div>
					<div class="modal-footer panel-footer">
						<div class="pull-left loader">
							<i class="fa fa-circle-o-notch fa-spin"></i> Loading...
						</div>
						<button type="button" class="btn btn-default" data-dismiss="modal">
							Close
						</button>
						<button type="button" class="btn btn-primary modal-submit">
							Submit
						</button>
					</div>
				</div>
			</div>
		</div>

	{$footeroutput}
	{/if}
	
	{if $showingLoginPage}
		<script type="text/javascript">
			$("p:contains('Powered by')").remove();
		</script>
	{/if}
	</body>
</html>