{foreach from=$menu item=item}
    <li{if $item.css_id} id="{$item.css_id}"{/if} class="{if $item.children}active{/if}{if $item.css_class} {$item.css_class}{/if}">
        <a {if $item.children}href="javascript:;"{else} href="{$item.fullurl}" target="{$item.targetwindow}"{if $item.attributes} {$item.attributes}{/if}{/if} data-original-title="{$item.title}">
            {if $item.css_icon}<span aria-hidden="true" class="{$item.css_icon}"></span>{/if}
            <span class="hidden-minibar"> {$item.title}</span>
            {if $item.badge!=="none"}<span class="badge badge-default pull-right flip">{$item.badge}</span>{/if}
        </a>
        {* Level 2 *}
        {if $item.children}
        <ul style="display:none;">
            {foreach from=$item.children item=level2}
            <li{if $level2.css_id} id="{$level2.css_id}"{/if}{if $level2.css_class} class="{$level2.css_class}"{/if}>
                <a href="{$level2.fullurl}" class="dropdown" target="{$level2.targetwindow}"{if $level2.attributes} {$level2.attributes}{/if} data-original-title="{$level2.title}">
                    <span class="hidden-minibar"> {$level2.title}</span>
                    {if $level2.badge!=="none"}<span class="badge badge-default pull-right flip">{$level2.badge}</span>{/if}
                </a>
            </li>
            {/foreach}
        </ul>
        {/if}
    </li>
{/foreach}