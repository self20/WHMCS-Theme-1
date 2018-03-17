<ul class="nav navbar-nav{if $group.css_class} {$group.css_class}{/if}"{if $group.css_id} id="{$group.css_id}"{/if}>
{foreach from=$menu item=level1}
    <li{if $level1.css_id} id="{$level1.css_id}"{/if} class="{if $level1.children}dropdown{/if}{if $level1.css_class} {$level1.css_class}{/if}">
        <a{if $level1.children} href="#" class="dropdown-toggle" data-toggle="dropdown"{else} href="{$level1.fullurl}" target="{$level1.targetwindow}"{/if}{if $level1.attributes} {$level1.attributes}{/if}>
            {if $level1.css_icon}<i class="{$level1.css_icon}"></i>&nbsp;{/if}
            {$level1.title}
            {if $level1.badge!=="none"}&nbsp;<span class="badge">{$level1.badge}</span>{/if}
            {if $level1.children}&nbsp;<b class="caret"></b>{/if}
        </a>
        {* Level 2 *}
        {if $level1.children}
        <ul class="dropdown-menu multi-level">
            {foreach from=$level1.children item=level2}
            {if $level2.title=="-----"}
            <li class="divider"></li>
            {else}
            <li class="{if $level2.children}dropdown-submenu{/if}{if $level2.css_class} {$level2.css_class}{/if}"{if $level2.css_id} id="{$level2.css_id}"{/if}>
                <a{if $level2.children} href="#" class="dropdown-toggle" data-toggle="dropdown"{else} href="{$level2.fullurl}" target="{$level2.targetwindow}"{/if}{if $level2.attributes} {$level2.attributes}{/if}>
                    {if $level2.css_icon}<i class="{$level2.css_icon}"></i>&nbsp;{/if}
                    {$level2.title}
                    {if $level2.badge!=="none"}&nbsp;<span class="badge">{$level2.badge}</span>{/if}
                </a>
                {* Level 3 *}
                {if $level2.children}
                <ul class="dropdown-menu">
                    {foreach from=$level2.children item=level3}
                    {if $level3.title=="-----"}
                    <li class="divider"></li>
                    {else}
                    <li class="{if $level3.children}dropdown-submenu{/if}{if $level3.css_class} {$level3.css_class}{/if}"{if $level3.css_id} id="{$level3.css_id}"{/if}>
                        <a{if $level3.children} href="#" class="dropdown-toggle" data-toggle="dropdown"{else} href="{$level3.fullurl}" target="{$level3.targetwindow}"{/if}{if $level3.attributes} {$level3.attributes}{/if}>
                            {if $level3.css_icon}<i class="{$level3.css_icon}"></i>&nbsp;{/if}
                            {$level3.title}
                            {if $level3.badge!=="none"}&nbsp;<span class="badge">{$level3.badge}</span>{/if}
                        </a>
                        {* Level 4 *}
                        {if $level3.children}
                        <ul class="dropdown-menu">
                            {foreach from=$level3.children item=level4}
                            {if $level4.title=="-----"}
                            <li class="divider"></li>
                            {else}
                            <li{if $level4.css_class} class="{$level4.css_class}"{/if}{if $level4.css_id} id="{$level4.css_id}"{/if}>
                                <a href="{$level4.fullurl}" target="{$level4.targetwindow}"{if $level4.attributes} {$level4.attributes}{/if}>
                                    {if $level4.css_icon}<i class="{$level4.css_icon}"></i>&nbsp;{/if}
                                    {$level4.title}
                                    {if $level4.badge!=="none"}&nbsp;<span class="badge">{$level4.badge}</span>{/if}
                                </a>
                            </li>
                            {/if}
                            {/foreach}
                        </ul>
                        {/if}
                    </li>
                    {/if}
                    {/foreach}
                </ul>
                {/if}
            </li>
            {/if}
            {/foreach}
        </ul>
        {/if}
    </li>
{/foreach}
</ul>

{literal}
<style>
.dropdown-submenu {
    position: relative;
}
.dropdown-submenu>.dropdown-menu {
    top: 0;
    left: 100%;
    margin-top: -6px;
    margin-left: -1px;
    -webkit-border-radius: 0 6px 6px 6px;
    -moz-border-radius: 0 6px 6px;
    border-radius: 0 6px 6px 6px;
}
.dropdown-submenu:hover>.dropdown-menu {
    display: block;
}
.dropdown-submenu>a:after {
    display: block;
    content: " ";
    float: right;
    width: 0;
    height: 0;
    border-color: transparent;
    border-style: solid;
    border-width: 5px 0 5px 5px;
    border-left-color: #ccc;
    margin-top: 5px;
    margin-right: -10px;
}
.dropdown-submenu:hover>a:after {
    border-left-color: #fff;
}
.dropdown-submenu.pull-left {
    float: none;
}
.dropdown-submenu.pull-left>.dropdown-menu {
    left: -100%;
    margin-left: 10px;
    -webkit-border-radius: 6px 0 6px 6px;
    -moz-border-radius: 6px 0 6px 6px;
    border-radius: 6px 0 6px 6px;
}
</style>
{/literal}