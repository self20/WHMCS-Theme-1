{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{if $sent}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.contactsent textcenter=true}
{/if}

{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

{if !$sent}
	<div class="row">
		<div class="col-md-12">
                  
			<!-- BEGIN FORM-->
			<form method="post" action="contact.php" role="form">
				<input type="hidden" name="action" value="send" />
				 
					<div class="well light">
						<div class="row">
							<div class="form-group col-lg-6">
								<label for="inputName">{$LANG.supportticketsclientname}</label>
								<input type="text" name="name" value="{$name}" class="form-control" id="inputName" />
							</div>
							<div class="form-group col-lg-6">
								<label for="inputEmail">{$LANG.supportticketsclientemail}</label>
								<input type="email" name="email" value="{$email}" class="form-control" id="inputEmail" />
							</div>

									
							<div class="clearfix"></div>

							<div class="form-group col-lg-12">
								<label for="inputSubject">{$LANG.supportticketsticketsubject}</label>
								<input type="subject" name="subject" value="{$subject}" class="form-control" id="inputSubject" />
							</div>
					  
							<div class="form-group col-lg-12">
								<label for="inputMessage">{$LANG.contactmessage}</label>
								<textarea name="message" rows="10" class="form-control" id="inputMessage">{$message}</textarea>
							</div>
							
							<div class="form-group col-lg-12">
								<label></label>
								{include file="$template/includes/captcha.tpl"}
							</div>
							
							<div class="form-group col-lg-12">
								<button type="submit" class="btn btn-success btn-lg"><i class="fa fa-send"></i>{$LANG.contactsend}</button>
							</div>
						</div>
					</div>
			</form>
			<!-- END FORM-->
						
		</div>
	</div>

{/if}
