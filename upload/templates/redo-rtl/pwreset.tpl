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
				
				<!-- BEGIN FORGOT BOX -->
				<div class="login-box visible">				
					<p class="bigger-110 text-uppercase">
						<i class="fa fa-key"></i> <b>{$LANG.pwreset}</b>
					</p>
					
					<div class="hr hr-8 hr-double dotted"></div>
					
					{if $loggedin}
						{include file="$template/includes/alert.tpl" type="error" msg=$LANG.noPasswordResetWhenLoggedIn textcenter=true}
					{else}
						{if $success}

							{include file="$template/includes/alert.tpl" type="success" msg=$LANG.pwresetvalidationsent textcenter=true}

							<p>{$LANG.pwresetvalidationcheckemail}</p>

						{else}

							{if $errormessage}
								{include file="$template/includes/alert.tpl" type="error" msg=$errormessage textcenter=true}
							{/if}

							{if $securityquestion}

								<p>{$LANG.pwresetsecurityquestionrequired}</p>

								<form method="post" action="pwreset.php"  class="form-stacked">
									<input type="hidden" name="action" value="reset" />
									<input type="hidden" name="email" value="{$email}" />

									<div class="form-group">
										<div class="input-icon right">
											<span class="fa fa-question text-gray"></span>
											<input type="text" name="answer" class="form-control" id="inputAnswer" placeholder="{$securityquestion}" autofocus>
										</div>
									</div>

									<div class="form-group text-center">
										<button type="submit" class="btn-login btn btn-primary btn-lg btn-block">{$LANG.pwresetsubmit}</button>
									</div>

								</form>

							{else}

								<p>{$LANG.pwresetemailneeded}</p>

								<form method="post" action="{$systemsslurl}pwreset.php" role="form">
									<input type="hidden" name="action" value="reset" />

									<div class="form-group">
										<div class="input-icon right">
											<span class="fa fa-envelope text-gray"></span>
											<input type="email" name="email" class="form-control" id="inputEmail" placeholder="{$LANG.enteremail}" autofocus>
										</div>
									</div>

									<div class="form-group text-center">
										<button type="submit" class="btn-login btn btn-primary btn-lg btn-block">{$LANG.pwresetsubmit}</button>
									</div>

								</form>

							{/if}

						{/if}
					{/if}

						
					<h3>{$LANG.registerintro}</h3>
					<a href="register.php" class="pull-left btn btn-secondary">{$LANG.register}</a>
					<a href="login.php" class="pull-right btn btn-inverse btn-line">{$LANG.goback}</a>
					
					<div class="clearfix"></div>
					

					<div class="login-copyright-text padding-all">
						<p class="smaller-90">{$LANG.copyright} &copy; {$date_year} {$companyname}. <span class="hidden-xs">{$LANG.allrightsreserved}.</span></p>
					</div>	

					
				</div>
				<!-- END FORGOT BOX -->
				
			</div>
			<!-- END MAIN PAGE CONTENT --> 
	</div>
