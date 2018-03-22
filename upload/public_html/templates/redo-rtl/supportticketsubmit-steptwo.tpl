{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

<form method="post" action="{$smarty.server.PHP_SELF}?step=3" enctype="multipart/form-data" role="form" class="form-horizontal">

    
        <div class="form-group">
            <label class="col-sm-3 control-label" for="inputName">{$LANG.supportticketsclientname}</label>
			<div class="col-sm-9">
				<input type="text" name="name" id="inputName" value="{if $loggedin}{$clientname}{else}{$name}{/if}" class="col-xs-12 col-sm-3{if $loggedin} disabled{/if}"{if $loggedin} disabled="disabled"{/if} />
			</div>
        </div>
		
        <div class="form-group">
            <label class="col-sm-3 control-label" for="inputEmail">{$LANG.supportticketsclientemail}</label>
			<div class="col-sm-9">
				<input type="email" name="email" id="inputEmail" value="{$email}" class="col-xs-12 col-sm-5{if $loggedin} disabled{/if}"{if $loggedin} disabled="disabled"{/if} />
			</div>
		</div>
   
		<hr class="separator">
		
        <div class="form-group">
            <label class="col-sm-3 control-label" for="inputSubject">{$LANG.supportticketsticketsubject}</label>
			<div class="col-sm-9">
				<input type="text" name="subject" id="inputSubject" value="{$subject}" class="col-xs-12 col-sm-8" />
			</div>
        </div>
    

        <div class="form-group">
            <label class="col-sm-3 control-label" for="inputDepartment">{$LANG.supportticketsdepartment}</label>
			<div class="col-sm-9">
				<select name="deptid" id="inputDepartment" class="col-xs-12 col-sm-3" onchange="refreshCustomFields(this)">
					{foreach from=$departments item=department}
						<option value="{$department.id}"{if $department.id eq $deptid} selected="selected"{/if}>
							{$department.name}
						</option>
					{/foreach}
				</select>
			</div>
        </div>
        {if $relatedservices}
            <div class="form-group">
                <label class="col-sm-3 control-label" for="inputRelatedService">{$LANG.relatedservice}</label>
				<div class="col-sm-9">
					<select name="relatedservice" id="inputRelatedService" class="col-xs-12 col-sm-3">
						<option value="">{$LANG.none}</option>
						{foreach from=$relatedservices item=relatedservice}
							<option value="{$relatedservice.id}">
								{$relatedservice.name} ({$relatedservice.status})
							</option>
						{/foreach}
					</select>
				</div>
            </div>
        {/if}
        <div class="form-group">
            <label class="col-sm-3 control-label" for="inputPriority">{$LANG.supportticketspriority}</label>
			<div class="col-sm-9">
				<select name="urgency" id="inputPriority" class="col-xs-12 col-sm-3">
					<option value="High"{if $urgency eq "High"} selected="selected"{/if}>
						{$LANG.supportticketsticketurgencyhigh}
					</option>
					<option value="Medium"{if $urgency eq "Medium" || !$urgency} selected="selected"{/if}>
						{$LANG.supportticketsticketurgencymedium}
					</option>
					<option value="Low"{if $urgency eq "Low"} selected="selected"{/if}>
						{$LANG.supportticketsticketurgencylow}
					</option>
				</select>
			</div>
        </div>
		
	<hr class="separator">
	
	
    <div class="form-group">
        <label class="col-sm-3 control-label" for="inputMessage">{$LANG.contactmessage}</label>
		<div class="col-sm-9">
			<textarea name="message" id="inputMessage" rows="12" class="col-xs-12 col-sm-8 markdown-editor" data-auto-save-name="client_ticket_open">{$message}</textarea>
		</div>
    </div>

	<hr class="separator">
	
    <div class="form-group">
        <label class="col-sm-3 control-label" for="inputAttachments">{$LANG.supportticketsticketattachments}</label>
        <div class="col-sm-6">
            <input type="file" name="attachments[]" id="inputAttachments" class="form-control" />
            <div id="fileUploadsContainer"></div>
			{$LANG.supportticketsallowedextensions}: {$allowedfiletypes}
			
			<div class="padding-all">
				<button type="button" class="btn btn-inverse btn-xs" onclick="extraTicketAttachment()">
					<i class="fa fa-plus"></i> {$LANG.addmore}
				</button>
			</div>
			
        </div>
	</div>


    <div id="customFieldsContainer">
        {include file="$template/supportticketsubmit-customfields.tpl"}
    </div>

    <div id="autoAnswerSuggestions" class="well hidden"></div>

    {include file="$template/includes/captcha.tpl"}

    <div class="clearfix form-actions">
		<div class="col-md-offset-3 col-md-9">
			<input type="submit" id="openTicketSubmit" value="{$LANG.supportticketsticketsubmit}" class="btn btn-success" />
			<a href="supporttickets.php" class="btn btn-default">{$LANG.cancel}</a>
		</div>
	</div>

</form>

{if $kbsuggestions}
    <script>
        jQuery(document).ready(function() {
            getTicketSuggestions();
        });
    </script>
{/if}
