{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{include file="$template/includes/tablelist.tpl" tableName="EmailsList" noSortColumns="-1"}

<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableEmailsList').removeClass('hidden').DataTable();
        {if $orderby == 'date'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject'}
            table.order(1, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>

<div class="table-container clearfix">
    <table id="tableEmailsList" class="datatable table table-hover table-bordered Redo-table table-primary hidden">
        <thead>
            <tr>
                <th data-hide="phone,tablet">{$LANG.clientareaemailsdate}</th>
                <th data-class="expand">{$LANG.clientareaemailssubject}</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$emails item=email}
            <tr onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '650', '450')">
                <td class="text-center"><span class="hidden">{$email.normalisedDate}</span>{$email.date}</td>
                <td>{$email.subject}</td>
                <td class="col-small center"><input type="button" class="btn btn-primary btn-xs" value="{$LANG.emailviewmessage}" onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '650', '450', 'scrollbars=1,')" /></td>
            </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fa fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
