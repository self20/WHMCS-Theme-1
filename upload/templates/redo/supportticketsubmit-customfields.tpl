{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}

{foreach from=$customfields item=customfield}
    <div class="form-group">
        <label class="col-sm-3 control-label" for="customfield{$customfield.id}">{$customfield.name}</label>
		 <div class="col-sm-4">
			{$customfield.input}
			{if $customfield.description}
				<span class="help-block">{$customfield.description}</span>
			{/if}
		</div>
    </div>
{/foreach}
