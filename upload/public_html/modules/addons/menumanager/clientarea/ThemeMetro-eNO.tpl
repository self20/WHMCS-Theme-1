{assign var="countup" value=0}
<ul id="side" class="nav navbar-nav side-nav{if $group.css_class} {$group.css_class}{/if}">
    <!-- BEGIN SIDE NAV MENU -->
    <li><h4>Navigation</h4></li>
    {foreach from=$menu item=item}
    {assign var="countup" value=$countup+1}
    <li{if $item.children} class="panel{if $item.css_class} {$item.css_class}{/if}"{/if}{if $item.css_id} id="{$item.css_id}"{/if}>
        {if $item.children}
        <a href="javascript:;" data-parent="#side" data-toggle="collapse" class="accordion-toggle" data-target="#m-{$countup}"{if $item.attributes} {$item.attributes}{/if}>
        {else}
        <a href="{$item.fullurl}" target="{$item.targetwindow}"{if $item.attributes} {$item.attributes}{/if}>
        {/if}
            {if $item.css_icon}<i class="{$item.css_icon}"></i> {/if}
            <span class="mtext">{$item.title}</span>
            {if $item.badge!=="none"} <span class="badge">{$item.badge}</span>{/if}
            {if $item.children} <span class="fa arrow"></span>{/if}
        </a>
        {* Level 2 *}
        {if $item.children}
        <ul class="collapse nav" id="#m-{$countup}">
            {foreach from=$item.children item=level2}
            <li{if $level2.css_id} id="{$level2.css_id}"{/if}{if $level2.css_class} class="{$level2.css_class}"{/if}>
                <a href="{$level2.fullurl}" target="{$level2.targetwindow}"{if $level2.attributes} {$level2.attributes}{/if}>
                    {$level2.title}
                    {if $level2.badge!=="none"} <span class="badge">{$level2.badge}</span>{/if}
                </a>
            </li>
            {/foreach}
        </ul>
        {/if}
    </li>
    {/foreach}
</ul>