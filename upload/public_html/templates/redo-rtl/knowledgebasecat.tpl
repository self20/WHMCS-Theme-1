{*
 **********************************************************
 * Developed by: Team Theme Metro
 * Website: http://www.thememetro.com
 **********************************************************
*}


<form role="form" method="post" action="{routePath('knowledgebase-search')}">
    <div class="input-group input-group-lg kb-search">
        <input type="text" name="search" class="form-control input-lg" placeholder="{$LANG.kbsearchexplain}" value="{$searchterm}" />
        <span class="input-group-btn">
            <input type="submit" id="btnKnowledgebaseSearch" class="btn btn-primary btn-input-padded-responsive" value="{$LANG.search}" />
        </span>
    </div>
</form>

<div class="space-32"></div>

{if $kbcats}
    <h4 class="bolder">{$LANG.knowledgebasecategories}</h4>

    <div class="row kbcategories">
        {foreach name=kbasecats from=$kbcats item=kbcat}
            <div class="col-sm-4">
                <a  href="{routePath('knowledgebase-category-view',{$kbcat.id},{$kbcat.urlfriendlyname})}">
                    <span class="glyphicon glyphicon-folder-close"></span> {$kbcat.name} <span class="badge badge-info">{$kbcat.numarticles}</span>
                </a>
                <p>{$kbcat.description}</p>
            </div>
        {/foreach}
    </div>
{/if}

{if $kbarticles || !$kbcats}
    {if $tag}
        <h4 class="bolder">{$LANG.kbviewingarticlestagged} '{$tag}'</h4>
    {else}
        <h4 class="bolder">{$LANG.knowledgebasearticles}</h4>
    {/if}

    <div class="kbarticles">
        {foreach from=$kbarticles item=kbarticle}
            <a href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}">
                <span class="glyphicon glyphicon-file"></span>&nbsp;{$kbarticle.title}
            </a>
            <p>{$kbarticle.article|truncate:100:"..."}</p>
        {foreachelse}
            {include file="$template/includes/alert.tpl" type="info" msg=$LANG.knowledgebasenoarticles textcenter=true}
        {/foreach}
    </div>
{/if}
