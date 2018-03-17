<div class="row">
    <div class="col-lg-10">{$breadcrumbs}</div>
    <div class="col-lg-2">
        <a href="#AddGroup" data-toggle="modal" class="btn btn-sm btn-block btn-primary"><i class="fa fa-plus"></i> New Group</a>
    </div>
</div>

<div class="clear-line-20"></div>

<ul class="list-group menu-group-list">
    {foreach item=group from=$groups}
    <li class="list-group-item">
        <div class="row">
            <div class="col-lg-6 text-left">{$group.name}</div>
            <div class="col-lg-2 text-center">
                {if $group.isprimary eq 1}
                <div class="label label-success">PRIMARY</div>
                {/if}
                {if $group.issecondary eq 1}
                <div class="label label-success">SECONDARY</div>
                {/if}
            </div>
            <div class="col-lg-2 text-center">
                <a href="{$modurl}&action=listitems&groupid={$group.id}" class="btn btn-sm btn-info">Manage Menu Items</a>
            </div>
            <div class="col-lg-2 text-center">
                <button type="button" data-toggle="modal" data-target="#IntegrationCode_{$group.id}" class="btn btn-sm btn-info" title="Integration Code"><i class="fa fa-code"></i></button>
                <a href="#UpdateGroup_{$group.id}" data-toggle="modal" class="btn btn-sm btn-warning" title="Update Group"><i class="fa fa-pencil"></i></a>
                <a href="#DeleteGroup_{$group.id}" data-toggle="modal" class="btn btn-sm btn-danger" title="Delete Group"><i class="fa fa-times"></i></a>
            </div>
        </div>
    </li>
    {foreachelse}
    <li class="list-group-item text-center">No Groups Created Yet</li>
    {/foreach}
</ul>

{* Group Delete Modal *}
{foreach item=group from=$groups}
<div id="DeleteGroup_{$group.id}" class="modal fade modal-delete">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="{$modurl}&action=deletegroup&id={$group.id}" method="post">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Delete "{$group.name}"</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this group "<b>{$group.name}</b>"?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-sm btn-danger">Delete Group</button>
            </div>
            </form>
        </div>
    </div>
</div>
{/foreach}

{* Group Update Modal *}
{foreach item=group from=$groups}
<div id="UpdateGroup_{$group.id}" class="modal fade modal-update">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="{$modurl}&action=updategroup&id={$group.id}" method="post">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Update "{$group.name}"</h4>
            </div>
            <div class="modal-body">
                <div class="menumanager-tabs">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active">
                            <a href="#groupmain_{$group.id}" aria-controls="groupmain_{$group.id}" role="tab" data-toggle="tab">General</a>
                        </li>
                        <li role="presentation">
                            <a href="#groupadvanced_{$group.id}" aria-controls="groupadvanced_{$group.id}" role="tab" data-toggle="tab">Advanced</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="groupmain_{$group.id}">
                            <div class="form-group">
                                <label for="name_{$group.id}">Group Name</label>
                                <input type="text" name="name" id="name_{$group.id}" value="{$group.name}" placeholder="Enter Group Name..." class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="template_{$group.id}">Template</label>
                                <select name="template" id="template_{$group.id}" class="form-control">
                                    {foreach item=comtemp from=$compatibletemplates}
                                    <option value="{$comtemp.short}"{if $group.template==$comtemp.short} selected{/if}>{$comtemp.name}</option>
                                    {/foreach}
                                </select>
                                <small class="help-block">Choose "Default" if you can't see your template name on the list.</small>
                            </div>
                            <div class="form-group">
                                <label>Set this menu as:</label>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas_none" value="none"{if $group.isprimary eq 0 && $group.issecondary eq 0} checked{/if}>
                                        None
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas" value="primary"{if $group.isprimary eq 1} checked{/if}>
                                        Primary Navbar
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas_secondary" value="secondary"{if $group.issecondary eq 1} checked{/if}>
                                        Secondary Navbar
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="groupadvanced_{$group.id}">
                            <div class="form-group">
                                <label for="css_class_{$group.id}">Class</label>
                                <input type="text" name="css_class" id="css_class_{$group.id}" value="{$group.css_class}" placeholder="Use space to separate multiple classes.." class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="css_activeclass_{$group.id}">Active Menu Item Class</label>
                                <input type="text" name="css_activeclass" id="css_activeclass_{$group.id}" value="{$group.css_activeclass}" placeholder="used for current/active menu item, commonly 'active'" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="css_id_{$group.id}">ID</label>
                                <input type="text" name="css_id" id="css_id_{$group.id}" value="{$group.css_id}" placeholder="" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-sm btn-warning">Save Changes</button>
            </div>
            </form>
        </div>
    </div>
</div>
{/foreach}

{* Group Create Modal *}
<div id="AddGroup" class="modal fade modal-create">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="{$modurl}&action=addgroup" method="post">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Create New Group</h4>
            </div>
            <div class="modal-body">
                <div class="menumanager-tabs">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active">
                            <a href="#groupmain" aria-controls="groupmain" role="tab" data-toggle="tab">General</a>
                        </li>
                        <li role="presentation">
                            <a href="#groupadvanced" aria-controls="groupadvanced" role="tab" data-toggle="tab">Advanced</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="groupmain">
                            <div class="form-group">
                                <label for="name">Group Name</label>
                                <input type="text" name="name" id="name" value="" placeholder="Enter Group Name..." class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="template">Template</label>
                                <select name="template" id="template" class="form-control">
                                    {foreach item=comtemp from=$compatibletemplates}
                                    <option value="{$comtemp.short}">{$comtemp.name}</option>
                                    {/foreach}
                                </select>
                                <small class="help-block">Choose "Default" if you can't see your template name on the list.</small>
                            </div>
                            <div class="form-group">
                                <label for="installdefault">Install Default Menu</label>
                                <select name="installdefault" id="installdefault" class="form-control">
                                    <option value="none">None</option>
                                    <option value="primary">Install WHMCS Primary Navbar</option>
                                    <option value="secondary">Install WHMCS Secondary Navbar</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Set this menu as:</label>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas_none" value="none" checked>
                                        None
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas" value="primary">
                                        Primary Navbar
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="setas" id="setas_secondary" value="secondary">
                                        Secondary Navbar
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="groupadvanced">
                            <div class="form-group">
                                <label for="css_class">Class</label>
                                <input type="text" name="css_class" id="css_class" value="" placeholder="Use space to separate multiple classes.." class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="css_activeclass">Active Menu Item Class</label>
                                <input type="text" name="css_activeclass" id="css_activeclass" value="active" placeholder="used for current/active menu item, commonly 'active'" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="css_id">ID</label>
                                <input type="text" name="css_id" id="css_id" value="" placeholder="" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-sm btn-primary">Add Group</button>
            </div>
            </form>
        </div>
    </div>
</div>

{* Group Integration Code Modal *}
{foreach item=group from=$groups}
<div id="IntegrationCode_{$group.id}" class="modal fade modal-default">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{$group.name}'s Integration Code</h4>
            </div>
            <div class="modal-body">
                <div class="help-block">Place the following code where you need this menu to be displayed.</div>
                {literal}<pre>{$menumanager_{/literal}{$group.id}{literal}}</pre>{/literal}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
{/foreach}