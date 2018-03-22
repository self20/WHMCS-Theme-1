{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}

	<div id="wrapper">
			<!-- BEGIN MAIN PAGE CONTENT -->
			
			<div class="login-container">
			
				<div class="login-header">
				
					<a href="{$WEB_ROOT}/">
						<img src="{$WEB_ROOT}/templates/{$template}/assets/images/logo.png" alt="logo" class="img-responsive">
					</a>					
					
				</div>
				
				<!-- BEGIN LOGIN BOX -->
				<div id="login-box" class="login-box visible">					
					<p class="bigger-110 text-uppercase">
						<i class="fa fa-key"></i> <b>{$LANG.account} {$LANG.login}</b>
					</p>
					

					
					<div class="hr hr-16 hr-double dotted"></div>
					
					{if $incorrect}
						{include file="$template/includes/alert.tpl" type="error" msg=$LANG.loginincorrect textcenter=true}
					{elseif $verificationId && empty($transientDataName)}
						{include file="$template/includes/alert.tpl" type="error" msg=$LANG.verificationKeyExpired textcenter=true}
					{elseif $ssoredirect}
						{include file="$template/includes/alert.tpl" type="info" msg=$LANG.sso.redirectafterlogin textcenter=true}
					{/if}
					

					
					<form method="post" action="{$systemurl}dologin.php">
						<div class="form-group">
							<div class="input-icon right">
								<span class="fa fa-key text-gray"></span>
								<input type="email" name="username" class="form-control" id="inputEmail" placeholder="{$LANG.enteremail}" autofocus>
							</div>
						</div>
						<div class="form-group">
							<div class="input-icon right">
								<span class="fa fa-lock text-gray"></span>
								<input type="password" name="password" class="form-control" id="inputPassword" placeholder="{$LANG.clientareapassword}" autocomplete="off" >
							</div>
						</div>			
						
						
						<div class="footer-warp">
												
							<div class="tcb pull-left">
								<label>
									<input type="checkbox" class="Redo" type="checkbox" name="rememberme" />
									<span class="labels"> {$LANG.loginrememberme}</span>
								</label>							
							</div>
							
							<div class="pull-right">
								<a href="pwreset.php" class="text-underline">{$LANG.loginforgotteninstructions}</a>
							</div>
							
							<div class="clearfix"></div>
							
							<input id="login" type="submit" class="btn-login btn btn-primary btn-lg btn-block" value="{$LANG.loginbutton}" /> 
							<p><small>{$LANG.sso.redirectafterlogin}</small></p>
							
						</div>
						
					</form>
					
					<div class="providerLinkingFeedback"></div>
					
					
					<div class="padding-all">
						{include file="$template/includes/linkedaccounts.tpl" linkContext="login" customFeedback=true}
					</div>
						
					<h3>{$LANG.registerintro}</h3>
					<a href="register.php" class="pull-left btn btn-secondary">{$LANG.register}</a>
					<a href="{$WEB_ROOT}/" class="pull-right btn btn-inverse btn-line">{$LANG.returnhome}</a>
						
					<div class="clearfix"></div>
						
					
					
					<div class="login-copyright-text padding-all">
						<p class="smaller-90">{$LANG.copyright} &copy; {$date_year} {$companyname}. <span class="hidden-xs">{$LANG.allrightsreserved}.</span></p>
					</div>
				</div>
				<!-- END LOGIN BOX -->
				
			</div>
			<!-- END MAIN PAGE CONTENT --> 
	</div>

