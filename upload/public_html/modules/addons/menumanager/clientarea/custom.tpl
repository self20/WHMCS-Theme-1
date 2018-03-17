<ul{if $group.css_class} class="{$group.css_class}"{/if}{if $group.css_id} id="{$group.css_id}"{/if}>
    {foreach from=$menu item=item}
    <li{if $item.css_id} id="{$item.css_id}"{/if}{if $item.css_class} class="{$item.css_class}"{/if}>
        <a href="{$item.fullurl}" target="{$item.targetwindow}"{if $item.attributes} {$item.attributes}{/if}>
            {if $item.css_icon}<i class="{$item.css_icon}"></i>&nbsp;{/if}
            {$item.title}
            {if $item.badge!=="none"}&nbsp;<span class="badge">{$item.badge}</span>{/if}
        </a>
        {* Level 2 *}
        {if $item.children}
        <ul>
            {foreach from=$item.children item=level2}
            <li{if $level2.css_id} id="{$level2.css_id}"{/if}{if $level2.css_class} class="{$level2.css_class}"{/if}>
                <a href="{$level2.fullurl}" target="{$level2.targetwindow}"{if $level2.attributes} {$level2.attributes}{/if}>
                    {if $level2.css_icon}<i class="{$level2.css_icon}"></i>&nbsp;{/if}
                    {$level2.title}
                    {if $level2.badge!=="none"}&nbsp;<span class="badge">{$level2.badge}</span>{/if}
                </a>
                {* Level 3 *}
                {if $level2.children}
                <ul>
                    {foreach from=$level2.children item=level3}
                    <li{if $level3.css_id} id="{$level3.css_id}"{/if}{if $level3.css_class} class="{$level3.css_class}"{/if}>
                        <a href="{$level3.fullurl}" target="{$level3.targetwindow}"{if $level3.attributes} {$level3.attributes}{/if}>
                            {if $level3.css_icon}<i class="{$level3.css_icon}"></i>&nbsp;{/if}
                            {$level3.title}
                            {if $level3.badge!=="none"}&nbsp;<span class="badge">{$level3.badge}</span>{/if}
                        </a>
                        {* Level 4 *}
                        {if $level3.children}
                        <ul>
                            {foreach from=$level3.children item=level4}
                            <li{if $level4.css_id} id="{$level4.css_id}"{/if}{if $level4.css_class} class="{$level4.css_class}"{/if}>
                                <a href="{$level4.fullurl}" target="{$level4.targetwindow}"{if $level4.attributes} {$level4.attributes}{/if}>
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