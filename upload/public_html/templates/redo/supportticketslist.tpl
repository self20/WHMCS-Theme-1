{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


{include file="$template/includes/tablelist.tpl" tableName="TicketsList" filterColumn="2"}

<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableTicketsList').removeClass('hidden').DataTable();
        {if $orderby == 'did' || $orderby == 'dept'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject' || $orderby == 'title'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'lastreply'}
            table.order(3, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>

<div class="table-container clearfix">
    <table id="tableTicketsList" class="datatable table table-hover table-bordered Redo-table table-primary hidden">
        <thead>
            <tr>
                <th data-hide="phone,tablet">{$LANG.supportticketsdepartment}</th>
                <th data-class="expand">{$LANG.supportticketssubject}</th>
                <th>{$LANG.supportticketsstatus}</th>
                <th data-hide="phone,tablet">{$LANG.supportticketsticketlastupdated}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$tickets item=ticket}
                <tr onclick="window.location='viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}'">
                    <td>{$ticket.department}</td>
                    <td><a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}">{if $ticket.unread}<strong>{/if}#{$ticket.tid} - {$ticket.subject}{if $ticket.unread}</strong>{/if}</a></td>
                    <td><span class="label status {if is_null($ticket.statusColor)}status-{$ticket.statusClass}"{else}status-custom" style="border-color: {$ticket.statusColor}; color: {$ticket.statusColor}"{/if}>{$ticket.status|strip_tags}</span></td>
                    <td><span class="hidden">{$ticket.normalisedLastReply}</span>{$ticket.lastreply}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fa fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
