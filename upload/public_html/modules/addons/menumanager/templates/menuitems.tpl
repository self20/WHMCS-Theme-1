{if $action=="listitems"}
<div class="row">
    <div class="col-lg-10">{$breadcrumbs}</div>
    <div class="col-lg-2">
        <a href="{$modurl}&action=additem&groupid={$groupinfo.id}" class="btn btn-sm btn-block btn-primary"><i class="fa fa-plus"></i> New Menu Item</a>
    </div>
</div>

<div class="clear-line-20"></div>

<div class="row">
    <div class="col-lg-12">
        
        {function name=parsemenuchildren menuitems=$items}
        <ol{if $menuid!=''} id="{$menuid}"{/if}{if $menuclass!=''} class="{$menuclass}"{/if}>
            {foreach item=item from=$menuitems}
            <li id="list_{$item.id}">
                <div class="menu-item">
                    <div class="text-left pull-left">
                        <span>{$item.title}</span>
                    </div>
                    <div class="row pull-right">
                        <div class="col-lg-9 text-left">
                            <span class="text-mute" title="{$item.fullurl}">
                                {if $item.urltype!='customurl'}../{/if}{$item.fullurl|truncate:60}
                            </span>
                        </div>
                        <div class="col-lg-1 text-center">
                            {if $item.accesslevel=='1'}
                            <span data-toggle="tooltip" title="{$item.accesslevelexplain}"><i class="fa fa-circle always-on"></i></span>
                            {else if $item.accesslevel=='0'}
                            <span data-toggle="tooltip" title="{$item.accesslevelexplain}"><i class="fa fa-circle always-off"></i></span>
                            {else}
                            <span data-toggle="tooltip" title="{$item.accesslevelexplain}"><i class="fa fa-circle condition-apply"></i></span>
                            {/if}
                        </div>
                        <div class="col-lg-2 text-center">
                            <a href="{$modurl}&action=edititem&itemid={$item.id}" class="btn btn-sm btn-warning" title="Update Menu Item"><i class="fa fa-pencil"></i></a>
                            <a href="#DeleteItem_{$item.id}" data-toggle="modal" class="btn btn-sm btn-danger" title="Delete Menu Item"><i class="fa fa-times"></i></a>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
                
                {parsemenuchildren menuitems=$item.children menuid="" menuclass=""}
            
            </li>            
            {/foreach}
        </ol>
        {/function}
        
        {* Loop Menu *}
        {parsemenuchildren menuitems=$items menuid="sortable-menu" menuclass="menu-items-list sortable"}
        
        {* No Menu Items Created Yet *}
        {if $countitems=='0'}
        <p class="text-center">No Menu Items In This Group Created Yet.</p>
        {/if}
        
</div>
</div>


{* Item Delete Modal *}
{foreach item=item from=$items}
<div id="DeleteItem_{$item.id}" class="modal fade modal-delete">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="{$modurl}&action=deleteitem&id={$item.id}&groupid={$item.groupid}" method="post">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Delete "{$item.title}"</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this item "<b>{$item.title}</b>"?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-sm btn-danger">Delete Menu Item</button>
            </div>
            </form>
        </div>
    </div>
</div>
    {foreach item=level2 from=$item.children}
    <div id="DeleteItem_{$level2.id}" class="modal fade modal-delete">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="{$modurl}&action=deleteitem&id={$level2.id}&groupid={$item.groupid}" method="post">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Delete "{$level2.title}"</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this item "<b>{$level2.title}</b>"?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-sm btn-danger">Delete Menu Item</button>
                </div>
                </form>
            </div>
        </div>
    </div>
        {foreach item=level3 from=$level2.children}
        <div id="DeleteItem_{$level3.id}" class="modal fade modal-delete">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="{$modurl}&action=deleteitem&id={$level3.id}&groupid={$item.groupid}" method="post">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Delete "{$level3.title}"</h4>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete this item "<b>{$level3.title}</b>"?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-sm btn-danger">Delete Menu Item</button>
                    </div>
                    </form>
                </div>
            </div>
        </div>
            {foreach item=level4 from=$level3.children}
            <div id="DeleteItem_{$level4.id}" class="modal fade modal-delete">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="{$modurl}&action=deleteitem&id={$level4.id}&groupid={$item.groupid}" method="post">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Delete "{$level4.title}"</h4>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete this item "<b>{$level4.title}</b>"?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-sm btn-danger">Delete Menu Item</button>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
            {/foreach}
        {/foreach}
    {/foreach}
{/foreach}



{elseif $action=="additem"}

<div class="row">
    <div class="col-lg-12">{$breadcrumbs}</div>
</div>

<div class="clear-line-10"></div>

<form action="{$modurl}&action=doadditem" method="post" autocomplete="off">
<input type="hidden" name="groupid" value="{$groupid}">
<div class="row">
    <div class="col-lg-8">
        <div class="menumanager-tabs">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active">
                    <a href="#general" aria-controls="general" role="tab" data-toggle="tab">General</a>
                </li>
                <li role="presentation">
                    <a href="#translations" aria-controls="translations" role="tab" data-toggle="tab">Translations</a>
                </li>
                <li role="presentation">
                    <a href="#attributes" aria-controls="attributes" role="tab" data-toggle="tab">Attributes</a>
                </li>
            </ul>
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="general">
                    <div class="form-group">
                        <label for="parentid">Parent Menu</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <select name="parentid" id="parentid" class="form-control input-sm">
                                    <option value="0">No Parent</option>
                                    {foreach from=$parentlist item=item}
                                    <option value="{$item.id}">{$item.title}</option>
                                        {foreach from=$item.sub item=level2}
                                        <option value="{$level2.id}">-- -- {$level2.title}</option>
                                            {foreach from=$level2.sub item=level3}
                                            <option value="{$level3.id}">-- -- -- -- {$level3.title}</option>
                                            {/foreach}
                                        {/foreach}
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="title">Title</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <input type="text" name="title" id="title" class="form-control input-sm" placeholder="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="accesslevel">Status</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <select name="accesslevel" id="accesslevel" class="form-control input-sm">
                                    <optgroup label="Common:">
                                        <option value="1">Always enabled</option>
                                        <option value="0">Always disabled</option>
                                        <option value="2">Enabled for visitors only</option>
                                        <option value="3">Enabled for clients only</option>
                                        <option value="14">Enabled for Affiliates only</option>
                                    </optgroup>
                                    <optgroup label="Enabled for clients if they have:">
                                        <option value="4">Active Product(s)</option>
                                        <option value="5">Overdue Invoice(s)</option>
                                        <option value="6">Active Ticket(s)</option>
                                        <option value="7">Active Domain(s)</option>
                                    </optgroup>
                                    <optgroup label="Enabled if one of this settings is available:">
                                        <option value="8">Manage Credit Cards</option>
                                        <option value="9">Add Funds</option>
                                        <option value="10">Mass Pay</option>
                                        <option value="11">Domain Registration</option>
                                        <option value="12">Domain Transfer</option>
                                        <option value="13">Affiliates</option>
                                    </optgroup>
                                    <option value="15"{if $iteminfo.accesslevel=='15'} selected{/if}>Client is in on of the selected groups</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id="client-groups-div" class="form-group" style="display:none">
                        <div class="row">
                            <div class="col-lg-6">
                                <label for="clientgroups">Client Groups</label>
                                <select name="clientgroups[]" id="clientgroups" class="form-control" multiple>
                                    {foreach item=group from=$clientgroups}
                                    <option value="{$group.id}">{$group.groupname}</option>
                                    {/foreach}
                                </select>
                                <div class="help-block small">Click <kbd>CTRL</kbd> + <kbd>Click</kbd> to select multiple groups.<br>if no groups selected it will be considered "Enabled for clients only" without restrictions.</div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="target">Target URL</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <select name="urltype" id="urltype" class="form-control input-sm">
                                        <option value="clientarea-off">Core URL Available To Anyone</option>
                                        <option value="clientarea-on">Core URL Available To Logged-in Clients Only</option>
                                        <option value="support">Support Department</option>
                                        <option value="customurl">External/Custom URL</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <select name="clientarea-off" id="clientarea-off" class="form-control input-sm" style="display:;">
                                        <option value="index.php">Portal Home</option>
                                        <option value="downloads.php">Downloads</option>
                                        <option value="knowledgebase.php">Knowledgebase</option>
                                        <option value="domainchecker.php">Domain Checker</option>
                                        <option value="cart.php">Order</option>
                                        <option value="announcements.php">Announcements</option>
                                        <option value="submitticket.php">Open New Ticket</option>
                                        <option value="affiliates.php">Affiliates</option>
                                        <option value="contact.php">Contact Us</option>
                                        <option value="login.php">Login Page</option>
                                        <option value="register.php">Register Account</option>
                                        <option value="pwreset.php">Forgot Password</option>
                                        <option value="cart.php?a=add&domain=register">Register a New Domain</option>
                                        <option value="cart.php?a=add&domain=transfer">Transfer Domains to Us</option>
                                        <option value="cart.php?a=view">View Cart</option>
                                    </select>
                                    
                                    <select name="clientarea-on" id="clientarea-on" class="form-control input-sm" style="display:none;">
                                        <option value="clientarea.php">Client Summary</option>
                                        <option value="networkissues.php">Network Issues</option>
                                        <option value="serverstatus.php">Servers Status</option>
                                        <option value="supporttickets.php">Support Tickets</option>
                                        <option value="clientarea.php?action=products">My Services</option>
                                        <option value="cart.php?gid=addons">View Available Addons</option>
                                        <option value="clientarea.php?action=domains">My Domain</option>
                                        <option value="cart.php?gid=renewals">Renew Domains</option>
                                        <option value="clientarea.php?action=invoices">My Invoices</option>
                                        <option value="clientarea.php?action=creditcard">Manage Credit Card</option>
                                        <option value="clientarea.php?action=addfunds">Add Funds</option>
                                        <option value="clientarea.php?action=quotes">My Quotes</option>
                                        <option value="clientarea.php?action=masspay&all=true">Mass Payment</option>
                                        <option value="clientarea.php?action=details">Edit Account Details</option>
                                        <option value="clientarea.php?action=contacts">Contacts/Sub-Accounts</option>
                                        <option value="clientarea.php?action=emails">Email History</option>
                                        <option value="clientarea.php?action=changepw">Change Password</option>
                                        <option value="clientarea.php?action=security">Security Settings</option>
                                        <option value="logout.php">Logout</option>
                                    </select>
                                    
                                    <select name="support" id="support" class="form-control input-sm" style="display:none;">
                                        {foreach from=$supportdepartments item=department}
                                        <option value="{$department.id}">{$department.name}</option>
                                        {/foreach}
                                    </select>
                                    
                                    <input type="text" name="customurl" id="customurl" class="form-control input-sm" placeholder="Specify anything here to be used as the URL.." style="display:none;">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="translations">
                    <div class="clear-line-20"></div>
                    <div class="panel-group" id="translationpanels" role="tablist" aria-multiselectable="true">
                        {foreach from=$languages item=language}
                        <input type="hidden" name="translation_languages[]" value="{$language}">
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading_{$language}">
                                <h4 class="panel-title">
                                    <a role="button" data-toggle="collapse" data-parent="#translationpanels" href="#{$language}" aria-expanded="true" aria-controls="{$language}">
                                        <i class="fa fa-plus"></i> {$language|ucfirst}
                                    </a>
                                </h4>
                            </div>
                            <div id="{$language}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_{$language}">
                                <div class="panel-body">
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <label for="translation_title[{$language}]" class="col-sm-2 control-label">Title</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="translation_title[{$language}]" class="form-control" id="translation_title[{$language}]" value="" placeholder="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="attributes">
                    <button type="button" class="btn btn-sm btn-info pull-right add-attribute-form" onclick="addAttribute();"><i class="fa fa-plus"></i> Add More</button>
                    <div class="clear"></div>
                    <div id="attributes-wrap">
                        <div class="row attributeform">
                            <div class="col-lg-4">
                                <input type="text" name="attrnames[]" value="" class="form-control input-sm" placeholder="Name">
                            </div>
                            <div class="col-lg-4">
                                <input type="text" name="attrvalues[]" value="" class="form-control input-sm" placeholder="Value">
                            </div>
                            <div class="col-lg-1">
                                <button type="button" class="btn btn-sm btn-danger delete-attribute-form" onclick="deleteAttribute(this);"><i class="fa fa-times"></i></button>
                            </div>
                        </div>
                    </div>
                    <div class="clear-line-20"></div>
                    <div class="alert alert-warning">
                    <small class="help-block">Use this section to define additional attributes for example <code> data-itemid="120" </code> or <code> id="menuitemid" </code>, this attributes will be added to <code>&lt;a&gt;</code>.</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-lg-offset-1">
        <div class="panel-group" id="extraoptions" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTargetWindow">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#targetwindow" aria-expanded="true" aria-controls="targetwindow">
                            Target Window
                        </a>
                    </h4>
                </div>
                <div id="targetwindow" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTargetWindow">
                    <div class="panel-body">
                        <small class="help-block">When someone click on that item URL, it will:</small>
                        <label class="label-radio">
                            <input type="radio" name="targetwindow" value="_self" checked="checked">
                            <span>Open in the same Tab/Window</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="targetwindow" value="_blank">
                            <span>Open in new Tab/Window</span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingBadge">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#badge" aria-expanded="true" aria-controls="badge">
                            Badge
                        </a>
                    </h4>
                </div>
                <div id="badge" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingBadge">
                    <div class="panel-body">
                        <small class="help-block">You can show the number of Unpaid invoices as an example to draw attention:</small>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="totalservices">
                            <span>Total Products/Services</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activeservices">
                            <span>Active Products/Services</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="totaldomains">
                            <span>Total Domains</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activedomains">
                            <span>Active Domains</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="dueinvoices">
                            <span>Due Invoices</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="overdueinvoices">
                            <span>Overdue Invoices</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activetickets">
                            <span>Active Tickets</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="creditbalance">
                            <span>Credit Balance</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="shoppingcartitems">
                            <span>Shopping Cart Items</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="none" checked="checked">
                            <span>None</span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingCSS">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#css" aria-expanded="true" aria-controls="css">
                            CSS
                        </a>
                    </h4>
                </div>
                <div id="css" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingCSS">
                    <div class="panel-body">
                        <div class="form-group">
                            <label for="css_class">Class</label>
                            <input type="text" name="css_class" id="css_class" value="" placeholder="Specify class name(s).." class="form-control input-sm">
                        </div>
                        <div class="form-group">
                            <label for="css_id">ID</label>
                            <input type="text" name="css_id" id="css_id" value="" placeholder="Specify ID for this menu item.." class="form-control input-sm">
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingIcon">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#icon" aria-expanded="true" aria-controls="icon">
                            Icon
                        </a>
                    </h4>
                </div>
                <div id="icon" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingIcon">
                    <div class="panel-body">
                        <small class="help-block">You can specify Icon class name here to be displayed in this item</small>
                        <input type="text" name="css_icon" id="css_icon" class="form-control input-sm" placeholder="ex: fa fa-times">
                    </div>
                </div>
            </div>
        </div>
        <div class="btn-group btn-group-sm btn-group-two" role="group" aria-label="...">
            <button type="submit" name="save" value="save" class="btn btn-info">Save</button>
            <button type="submit" name="close" value="close" class="btn btn-primary">Save & Close</button>
        </div>
    </div>
</div>
</form>

{***** Update Menu Item *****}
{else if $action=='edititem'}

<div class="row">
    <div class="col-lg-12">{$breadcrumbs}</div>
</div>

<div class="clear-line-10"></div>

<form action="{$modurl}&action=doedititem" method="post" autocomplete="off">
<input type="hidden" name="itemid" value="{$iteminfo.id}">
<input type="hidden" name="groupid" value="{$iteminfo.groupid}">
<input type="hidden" name="parentid" value="{$iteminfo.parentid}">
<input type="hidden" name="translationrecords" value="{$itemtranslationrecords}">
<div class="row">
    <div class="col-lg-8">
        <div class="menumanager-tabs">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active">
                    <a href="#general" aria-controls="general" role="tab" data-toggle="tab">General</a>
                </li>
                <li role="presentation">
                    <a href="#translations" aria-controls="translations" role="tab" data-toggle="tab">Translations</a>
                </li>
                <li role="presentation">
                    <a href="#attributes" aria-controls="attributes" role="tab" data-toggle="tab">Attributes</a>
                </li>
            </ul>
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="general">
                    <div class="form-group">
                        <label for="title">Title</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <input type="text" name="title" id="title" value="{$iteminfo.title}" class="form-control input-sm" placeholder="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="accesslevel">Status</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <select name="accesslevel" id="accesslevel" class="form-control input-sm">
                                    <optgroup label="Common:">
                                        <option value="1"{if $iteminfo.accesslevel=='1'} selected{/if}>Always enabled</option>
                                        <option value="0"{if $iteminfo.accesslevel=='0'} selected{/if}>Always disabled</option>
                                        <option value="2"{if $iteminfo.accesslevel=='2'} selected{/if}>Enabled for visitors only</option>
                                        <option value="3"{if $iteminfo.accesslevel=='3'} selected{/if}>Enabled for clients only</option>
                                        <option value="14"{if $iteminfo.accesslevel=='14'} selected{/if}>Enabled for Affiliates only</option>
                                    </optgroup>
                                    <optgroup label="Enabled for clients if they have:">
                                        <option value="4"{if $iteminfo.accesslevel=='4'} selected{/if}>Active Product(s)</option>
                                        <option value="5"{if $iteminfo.accesslevel=='5'} selected{/if}>Overdue Invoice(s)</option>
                                        <option value="6"{if $iteminfo.accesslevel=='6'} selected{/if}>Active Ticket(s)</option>
                                        <option value="7"{if $iteminfo.accesslevel=='7'} selected{/if}>Active Domain(s)</option>
                                    </optgroup>
                                    <optgroup label="Enabled if one of this settings is available:">
                                        <option value="8"{if $iteminfo.accesslevel=='8'} selected{/if}>Manage Credit Cards</option>
                                        <option value="9"{if $iteminfo.accesslevel=='9'} selected{/if}>Add Funds</option>
                                        <option value="10"{if $iteminfo.accesslevel=='10'} selected{/if}>Mass Pay</option>
                                        <option value="11"{if $iteminfo.accesslevel=='11'} selected{/if}>Domain Registration</option>
                                        <option value="12"{if $iteminfo.accesslevel=='12'} selected{/if}>Domain Transfer</option>
                                        <option value="13"{if $iteminfo.accesslevel=='13'} selected{/if}>Affiliates</option>
                                    </optgroup>
                                    <option value="15"{if $iteminfo.accesslevel=='15'} selected{/if}>Client is in on of the selected groups</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id="client-groups-div" class="form-group"{if $iteminfo.accesslevel!='15'}style="display:none"{/if}>
                        <div class="row">
                            <div class="col-lg-6">
                                <label for="clientgroups">Client Groups</label>
                                <select name="clientgroups[]" id="clientgroups" class="form-control" multiple>
                                    {foreach item=group from=$clientgroups}
                                    <option value="{$group.id}"{if in_array($group.id, $selectedclientgroups)} selected{/if}>{$group.groupname}</option>
                                    {/foreach}
                                </select>
                                <div class="help-block small">Click <kbd>CTRL</kbd> + <kbd>Click</kbd> to select multiple groups.<br>if no groups selected it will be considered "Enabled for clients only" without restrictions.</div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="target">Target URL</label>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <select name="urltype" id="urltype" class="form-control input-sm">
                                        <option value="clientarea-off"{if $iteminfo.urltype=='clientarea-off'} selected{/if}>Core URL Available To Anyone</option>
                                        <option value="clientarea-on"{if $iteminfo.urltype=='clientarea-on'} selected{/if}>Core URL Available To Logged-in Clients Only</option>
                                        <option value="support"{if $iteminfo.urltype=='support'} selected{/if}>Support Department</option>
                                        <option value="customurl"{if $iteminfo.urltype=='customurl'} selected{/if}>External/Custom URL</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <select name="clientarea-off" id="clientarea-off" class="form-control input-sm" style="display:{if $iteminfo.urltype=='clientarea-off'}block{else}none{/if};">
                                        <option value="index.php"{if $iteminfo.url=='index.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Portal Home</option>
                                        <option value="downloads.php"{if $iteminfo.url=='downloads.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Downloads</option>
                                        <option value="knowledgebase.php"{if $iteminfo.url=='knowledgebase.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Knowledgebase</option>
                                        <option value="domainchecker.php"{if $iteminfo.url=='domainchecker.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Domain Checker</option>
                                        <option value="cart.php"{if $iteminfo.url=='cart.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Order</option>
                                        <option value="announcements.php"{if $iteminfo.url=='announcements.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Announcements</option>
                                        <option value="submitticket.php"{if $iteminfo.url=='submitticket.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Open New Ticket</option>
                                        <option value="affiliates.php"{if $iteminfo.url=='affiliates.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Affiliates</option>
                                        <option value="contact.php"{if $iteminfo.url=='contact.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Contact Us</option>
                                        <option value="login.php"{if $iteminfo.url=='login.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Login Page</option>
                                        <option value="register.php"{if $iteminfo.url=='register.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Register Account</option>
                                        <option value="pwreset.php"{if $iteminfo.url=='pwreset.php' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Forgot Password</option>
                                        <option value="cart.php?a=add&domain=register"{if $iteminfo.url=='cart.php?a=add&domain=register' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Register a New Domain</option>
                                        <option value="cart.php?a=add&domain=transfer"{if $iteminfo.url=='cart.php?a=add&domain=transfer' && $iteminfo.urltype=='clientarea-off'} selected{/if}>Transfer Domains to Us</option>
                                        <option value="cart.php?a=view"{if $iteminfo.url=='cart.php?a=view' && $iteminfo.urltype=='clientarea-off'} selected{/if}>View Cart</option>
                                    </select>
                                    
                                    <select name="clientarea-on" id="clientarea-on" class="form-control input-sm" style="display:{if $iteminfo.urltype=='clientarea-on'}block{else}none{/if};">
                                        <option value="clientarea.php"{if $iteminfo.url=='clientarea.php' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Client Summary</option>
                                        <option value="networkissues.php"{if $iteminfo.url=='networkissues.php' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Network Issues</option>
                                        <option value="serverstatus.php"{if $iteminfo.url=='serverstatus.php' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Servers Status</option>
                                        <option value="supporttickets.php"{if $iteminfo.url=='supporttickets.php' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Support Tickets</option>
                                        <option value="clientarea.php?action=products"{if $iteminfo.url=='clientarea.php?action=products' && $iteminfo.urltype=='clientarea-on'} selected{/if}>My Services</option>
                                        <option value="cart.php?gid=addons"{if $iteminfo.url=='cart.php?gid=addons' && $iteminfo.urltype=='clientarea-on'} selected{/if}>View Available Addons</option>
                                        <option value="clientarea.php?action=domains"{if $iteminfo.url=='clientarea.php?action=domains' && $iteminfo.urltype=='clientarea-on'} selected{/if}>My Domain</option>
                                        <option value="cart.php?gid=renewals"{if $iteminfo.url=='cart.php?gid=renewals' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Renew Domains</option>
                                        <option value="clientarea.php?action=invoices"{if $iteminfo.url=='clientarea.php?action=invoices' && $iteminfo.urltype=='clientarea-on'} selected{/if}>My Invoices</option>
                                        <option value="clientarea.php?action=creditcard"{if $iteminfo.url=='clientarea.php?action=creditcard' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Manage Credit Card</option>
                                        <option value="clientarea.php?action=addfunds"{if $iteminfo.url=='clientarea.php?action=addfunds' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Add Funds</option>
                                        <option value="clientarea.php?action=quotes"{if $iteminfo.url=='clientarea.php?action=quotes' && $iteminfo.urltype=='clientarea-on'} selected{/if}>My Quotes</option>
                                        <option value="clientarea.php?action=masspay&all=true"{if $iteminfo.url=='clientarea.php?action=masspay&all=true' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Mass Payment</option>
                                        <option value="clientarea.php?action=details"{if $iteminfo.url=='clientarea.php?action=details' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Edit Account Details</option>
                                        <option value="clientarea.php?action=contacts"{if $iteminfo.url=='clientarea.php?action=contacts' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Contacts/Sub-Accounts</option>
                                        <option value="clientarea.php?action=emails"{if $iteminfo.url=='clientarea.php?action=emails' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Email History</option>
                                        <option value="clientarea.php?action=changepw"{if $iteminfo.url=='clientarea.php?action=changepw' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Change Password</option>
                                        <option value="clientarea.php?action=security"{if $iteminfo.url=='clientarea.php?action=security' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Security Settings</option>
                                        <option value="logout.php"{if $iteminfo.url=='logout.php' && $iteminfo.urltype=='clientarea-on'} selected{/if}>Logout</option>
                                    </select>
                                    
                                    <select name="support" id="support" class="form-control input-sm" style="display:{if $iteminfo.urltype=='support'}block{else}none{/if};">
                                        {foreach from=$supportdepartments item=department}
                                        <option value="{$department.id}"{if $iteminfo.url==$department.id && $iteminfo.urltype=='support'} selected{/if}>{$department.name}</option>
                                        {/foreach}
                                    </select>
                                    
                                    <input type="text" name="customurl" id="customurl" class="form-control input-sm" placeholder="Specify anything here to be used as the URL.." {if $iteminfo.urltype=='customurl'}value="{$iteminfo.url}"{/if} style="display:{if $iteminfo.urltype=='customurl'}block{else}none{/if};">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="translations">
                    <div class="clear-line-20"></div>
                    <div class="panel-group" id="translationpanels" role="tablist" aria-multiselectable="true">
                        {foreach from=$languages item=language}
                        <input type="hidden" name="translation_languages[]" value="{$language}">
                        <div class="panel panel-{if $itemtranslations.title.$language!=""}info{else}default{/if}">
                            <div class="panel-heading" role="tab" id="heading_{$language}">
                                <h4 class="panel-title">
                                    <a role="button" data-toggle="collapse" data-parent="#translationpanels" href="#{$language}" aria-expanded="true" aria-controls="{$language}">
                                        <i class="fa fa-plus"></i> {$language|ucfirst}
                                    </a>
                                </h4>
                            </div>
                            <div id="{$language}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading_{$language}">
                                <div class="panel-body">
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <label for="translation_title[{$language}]" class="col-sm-2 control-label">Title</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="translation_title[{$language}]" class="form-control" id="translation_title[{$language}]" value="{$itemtranslations.title.$language}" placeholder="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
                <div role="tabpanel" class="tab-pane" id="attributes">
                    <button type="button" class="btn btn-sm btn-info pull-right add-attribute-form" onclick="addAttribute();"><i class="fa fa-plus"></i> Add More</button>
                    <div class="clear"></div>
                    <div id="attributes-wrap">
                        {foreach from=$attributes item=attribute}
                        <div class="row attributeform">
                            <div class="col-lg-4">
                                <input type="text" name="attrnames[]" value="{$attribute.name}" class="form-control input-sm" placeholder="Name">
                            </div>
                            <div class="col-lg-4">
                                <input type="text" name="attrvalues[]" value="{$attribute.value}" class="form-control input-sm" placeholder="Value">
                            </div>
                            <div class="col-lg-1">
                                <button type="button" class="btn btn-sm btn-danger delete-attribute-form" onclick="deleteAttribute(this);"><i class="fa fa-times"></i></button>
                            </div>
                        </div>
                        {foreachelse}
                        <div class="row attributeform">
                            <div class="col-lg-4">
                                <input type="text" name="attrnames[]" value="" class="form-control input-sm" placeholder="Name">
                            </div>
                            <div class="col-lg-4">
                                <input type="text" name="attrvalues[]" value="" class="form-control input-sm" placeholder="Value">
                            </div>
                            <div class="col-lg-1">
                                <button type="button" class="btn btn-sm btn-danger delete-attribute-form" onclick="deleteAttribute(this);"><i class="fa fa-times"></i></button>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                    <div class="clear-line-20"></div>
                    <div class="alert alert-warning">
                    <small class="help-block">Use this section to define additional attributes for example <code> data-itemid="120" </code> or <code> id="menuitemid" </code>, this attributes will be added to <code>&lt;a&gt;</code>.</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-lg-offset-1">
        <div class="panel-group" id="extraoptions" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingInformation">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#information" aria-expanded="true" aria-controls="information">
                            Information
                        </a>
                    </h4>
                </div>
                <div id="information" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingInformation">
                    <div class="panel-body">
                        <small><b>Created:</b> {$iteminfo.datecreate}</small>
                        <small><b>Updated:</b> {$iteminfo.datemodify}</small>
                        <small><b>Translations:</b> {$totaltranslations} ({$totallanguages})</small>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTargetWindow">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#targetwindow" aria-expanded="true" aria-controls="targetwindow">
                            Target Window
                        </a>
                    </h4>
                </div>
                <div id="targetwindow" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTargetWindow">
                    <div class="panel-body">
                        <small class="help-block">When someone click on that item URL, it will:</small>
                        <label class="label-radio">
                            <input type="radio" name="targetwindow" value="_self"{if $iteminfo.targetwindow=='_self'} checked{/if}>
                            <span>Open in the same Tab/Window</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="targetwindow" value="_blank"{if $iteminfo.targetwindow=='_blank'} checked{/if}>
                            <span>Open in new Tab/Window</span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingBadge">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#badge" aria-expanded="true" aria-controls="badge">
                            Badge
                        </a>
                    </h4>
                </div>
                <div id="badge" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingBadge">
                    <div class="panel-body">
                        <small class="help-block">You can show the number of Unpaid invoices as an example to draw attention:</small>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="totalservices"{if $iteminfo.badge=='totalservices'} checked{/if}>
                            <span>Total Products/Services</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activeservices"{if $iteminfo.badge=='activeservices'} checked{/if}>
                            <span>Active Products/Services</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="totaldomains"{if $iteminfo.badge=='totaldomains'} checked{/if}>
                            <span>Total Domains</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activedomains"{if $iteminfo.badge=='activedomains'} checked{/if}>
                            <span>Active Domains</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="dueinvoices"{if $iteminfo.badge=='dueinvoices'} checked{/if}>
                            <span>Due Invoices</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="overdueinvoices"{if $iteminfo.badge=='overdueinvoices'} checked{/if}>
                            <span>Overdue Invoices</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="activetickets"{if $iteminfo.badge=='activetickets'} checked{/if}>
                            <span>Active Tickets</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="creditbalance"{if $iteminfo.badge=='creditbalance'} checked{/if}>
                            <span>Credit Balance</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="shoppingcartitems"{if $iteminfo.badge=='shoppingcartitems'} checked{/if}>
                            <span>Shopping Cart Items</span>
                        </label>
                        <label class="label-radio">
                            <input type="radio" name="badge" value="none"{if $iteminfo.badge=='none'} checked{/if}>
                            <span>None</span>
                        </label>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingCSS">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#css" aria-expanded="true" aria-controls="css">
                            CSS
                        </a>
                    </h4>
                </div>
                <div id="css" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingCSS">
                    <div class="panel-body">
                        <div class="form-group">
                            <label for="css_class">Class</label>
                            <input type="text" name="css_class" id="css_class" value="{$iteminfo.css_class}" placeholder="Specify class name(s).." class="form-control input-sm">
                        </div>
                        <div class="form-group">
                            <label for="css_id">ID</label>
                            <input type="text" name="css_id" id="css_id" value="{$iteminfo.css_id}" placeholder="Specify ID for this menu item.." class="form-control input-sm">
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingIcon">
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#extraoptions" href="#icon" aria-expanded="true" aria-controls="icon">
                            Icon
                        </a>
                    </h4>
                </div>
                <div id="icon" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingIcon">
                    <div class="panel-body">
                        <small class="help-block">You can specify Icon class name here to be displayed in this item</small>
                        <input type="text" name="css_icon" id="css_icon" value="{$iteminfo.css_icon}" class="form-control input-sm" placeholder="ex: fa fa-times">
                    </div>
                </div>
            </div>
        </div>
        <div class="btn-group btn-group-sm btn-group-two" role="group" aria-label="...">
            <button type="submit" name="save" value="save" class="btn btn-info">Save</button>
            <button type="submit" name="close" value="close" class="btn btn-primary">Save & Close</button>
        </div>
    </div>
</div>
</form>

{/if}

{* Attributes Form Syntax *}
<div id="attributesformsyntax" style="display:none;">
    <div class="row attributeform">
        <div class="col-lg-4">
            <input type="text" name="attrnames[]" class="form-control input-sm" placeholder="Name">
        </div>
        <div class="col-lg-4">
            <input type="text" name="attrvalues[]" class="form-control input-sm" placeholder="Value">
        </div>
        <div class="col-lg-1">
            <button type="button" class="btn btn-sm btn-danger delete-attribute-form" onclick="deleteAttribute(this);"><i class="fa fa-times"></i></button>
        </div>
    </div>
</div>