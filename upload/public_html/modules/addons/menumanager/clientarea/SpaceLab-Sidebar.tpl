<ul class="nav nav-pills nav-stacked{if $group.css_class} {$group.css_class}{/if}"{if $group.css_id} id="{$group.css_id}"{/if}>
    {foreach from=$menu item=item}
    <li{if $item.css_id} id="{$item.css_id}"{/if} class="{if $item.children}nav-dropdown{/if}{if $item.css_class} {$item.css_class}{/if}">
        <a {if $item.children}href="#" title="{$item.title}"{else}href="{$item.fullurl}" target="{$item.targetwindow}" title="{$item.title}"{if $item.attributes} {$item.attributes}{/if}{/if}>
            {if $item.css_icon}<i class="{$item.css_icon}"></i>&nbsp;{/if}
            {$item.title}
            {if $item.badge!=="none"}&nbsp;<span class="badge">{$item.badge}</span>{/if}
        </a>
        {* Level 2 *}
        {if $item.children}
        <ul class="nav-sub">
            {foreach from=$item.children item=level2}
            <li{if $level2.css_id} id="{$level2.css_id}"{/if} class="{if $level2.children}nav-dropdown{/if}{if $level2.css_class} {$level2.css_class}{/if}">
                <a {if $level2.children}href="#" title="{$level2.title}"{else}href="{$level2.fullurl}" target="{$level2.targetwindow}" title="{$level2.title}"{if $level2.attributes} {$level2.attributes}{/if}{/if}>
                    {if $level2.css_icon}<i class="{$level2.css_icon}"></i>&nbsp;{/if}
                    {$level2.title}
                    {if $level2.badge!=="none"}&nbsp;<span class="badge">{$level2.badge}</span>{/if}
                </a>
                {* Level 3 *}
                {if $level2.children}
                <ul class="nav-sub">
                    {foreach from=$level2.children item=level3}
                    <li{if $level3.css_id} id="{$level3.css_id}"{/if} class="{if $level3.children}nav-dropdown{/if}{if $level3.css_class} {$level3.css_class}{/if}">
                        <a {if $level3.children}href="#" title="{$level3.title}"{else}href="{$level3.fullurl}" target="{$level3.targetwindow}"{if $level3.attributes} {$level3.attributes}{/if}{/if}>
                            {if $level3.css_icon}<i class="{$level3.css_icon}"></i>&nbsp;{/if}
                            {$level3.title}
                            {if $level3.badge!=="none"}&nbsp;<span class="badge">{$level3.badge}</span>{/if}
                        </a>
                        {* Level 4 *}
                        {if $level3.children}
                        <ul class="nav-sub">
                            {foreach from=$level3.children item=level4}
                            <li{if $level4.css_id} id="{$level4.css_id}"{/if}{if $level4.css_class} class="{$level4.css_class}"{/if}>
                                <a href="{$level4.fullurl}" target="{$level4.targetwindow}" title="{$level4.title}"{if $level4.attributes} {$level4.attributes}{/if}>
                                    {if $level4.css_icon}<i class="{$level4.css_icon}"></i>&nbsp;{/if}
                                    {$level4.title}
                                    {if $level4.badge!=="none"}&nbsp;<span class="badge">{$level4.badge}</span>{/if}
                                </a>
                            </li>
                            {/foreach}
                        </ul>
                        {/if}
                    </li>
                    {/foreach}
                </ul>
                {/if}
            </li>
            {/foreach}
        </ul>
        {/if}
    </li>
    {/foreach}
</ul>