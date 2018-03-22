{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


<form role="form" method="post" action="{routePath('knowledgebase-search')}">
    <div class="input-group input-group-lg kb-search">
        <input type="text" id="inputKnowledgebaseSearch" name="search" class="form-control" placeholder="What can we help you with?" />
        <span class="input-group-btn">
            <input type="submit" id="btnKnowledgebaseSearch" class="btn btn-primary btn-input-padded-responsive" value="{$LANG.search}" />
        </span>
    </div>
</form>

<div class="space-32"></div>



{if $kbcats}
	<h4 class="bolder">{$LANG.knowledgebasecategories}</h4>
	
    <div class="row">
        {foreach from=$kbcats name=kbcats item=kbcat}
            <div class="col-sm-4">
                <a href="{routePath('knowledgebase-category-view', {$kbcat.id}, {$kbcat.urlfriendlyname})}">
                    <i class="fa fa-folder-open-o"></i>
                    {$kbcat.name} ({$kbcat.numarticles})
                </a>
                <p>{$kbcat.description}</p>
            </div>
            {if $smarty.foreach.kbcats.iteration mod 3 == 0}
                </div><div class="row">
            {/if}
        {/foreach}
    </div>
{else}
    {include file="$template/includes/alert.tpl" type="info" msg=$LANG.knowledgebasenoarticles textcenter=true}
{/if}

{if $kbmostviews}

	<div class="space-32"></div>

    <h4 class="bolder">{$LANG.knowledgebasepopular}</h4>

    <div class="kbarticles">
        {foreach from=$kbmostviews item=kbarticle}
            <a href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}">
                <span class="glyphicon glyphicon-file"></span>&nbsp;{$kbarticle.title}
            </a>
            <p>{$kbarticle.article|truncate:100:"..."}</p>
        {/foreach}
    </div>

{/if}
