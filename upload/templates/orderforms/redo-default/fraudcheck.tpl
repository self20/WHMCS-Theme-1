{include file="orderforms/{$carttpl}/common.tpl"}


<div class="mass-head">
	<div class="hero-bg-wrap style-2 bg-opacity">
		<div class="container-fluid">		
			<div class="page-title">
				<h1>{$LANG.cartfraudcheck}</h1>
			</div>					
		</div>
	</div>
</div>



<div class="block-s3">
	<div class="container-fluid">
		<div id="order-standard_cart">

			<div class="row">

				<div class="col-md-12">
					
					{include file="orderforms/{$carttpl}/sidebar-categories-collapsed.tpl"}

				</div>

				<div class="col-md-12">

					<div class="alert alert-danger error-heading">
						<i class="fa fa-warning"></i>
						{$errortitle}
					</div>

					<div class="row">
						<div class="col-sm-8 col-sm-offset-2">

							<p class="margin-bottom">{$error}</p>

							<div class="text-center">
								<a href="submitticket.php" class="btn btn-default">
									{$LANG.orderForm.submitTicket}
									&nbsp;<i class="fa fa-arrow-right"></i>
								</a>
							</div>

						</div>
					</div>

				</div>
			</div>
		</div>
		
	</div>
</div>
