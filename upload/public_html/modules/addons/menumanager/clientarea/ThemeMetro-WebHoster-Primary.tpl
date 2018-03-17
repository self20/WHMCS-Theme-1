{foreach from=$menu item=item}
    <li{if $item.css_id} id="{$item.css_id}"{/if} class="{if $item.children}dropdown{/if}{if $item.css_class} {$item.css_class}{/if}">
        <a {if $item.children}class="dropdown-toggle" data-toggle="dropdown" href="#"{else}href="{$item.fullurl}" target="{$item.targetwindow}"{/if}{if $item.attributes} {$item.attributes}{/if}>
            {if $item.css_icon}<i class="{$item.css_icon}"></i>&nbsp;{/if}
            {$item.title}
            {if $item.badge!=="none"}&nbsp;<span class="badge">{$item.badge}</span>{/if}
            {if $item.children}&nbsp;<b class="caret"></b>{/if}
        </a>
        {* Level 2 *}
        {if $item.children}
        <ul class="dropdown-menu">
            {foreach from=$item.children item=level2}
            <li{if $level2.css_id} id="{$level2.css_id}"{/if}{if $level2.css_class} class="{$level2.css_class}"{/if}>
                <a href="{$level2.fullurl}" target="{$level2.targetwindow}"{if $level2.attributes} {$level2.attributes}{/if}>
                    {if $level2.css_icon}<i class="{$level2.css_icon}"></i>&nbsp;{/if}
                    {$level2.title}
                    {if $level2.badge!=="none"}&nbsp;<span class="badge">{$level2.badge}</span>{/if}
                </a>
            </li>
            {/foreach}
        </ul>
        {/if}
    </li>
{/foreach}