

<div class="page-header title hidden-xs">
    <h1>{$title} <span class="sub-title">{if $templatefile == 'viewticket'}#{$tid}{/if} {if $desc}{$desc}{/if}</span></h1>
    {if $showbreadcrumb}{include file="$template/includes/breadcrumb.tpl"}{/if}
</div>
<div class="page-header title visible-xs">
    <h1>{$title} <span class="sub-title">{if $templatefile == 'viewticket'}#{$tid}{/if} {if $desc}<br />{$desc}{/if}</span></h1>
    {if $showbreadcrumb}{include file="$template/includes/breadcrumb.tpl"}{/if}
</div>