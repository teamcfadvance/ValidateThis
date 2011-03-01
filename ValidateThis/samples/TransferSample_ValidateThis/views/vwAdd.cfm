<cfoutput>
<script language="javascript">
	function confirmDelete(){
	}
</script>

<div align="center" class="mainDiv">
	<div style="font-size:25px;font-weight:bold" align="left">
	Add User
	</div>

	<cfif StructKeyExists(rc,"VTResult")>
		<div align="left" style="margin-top:10px;border:1px solid red;background:##fffff0;padding:10px">
			The following problems were found with your form submission:
			<ul>
				<cfloop array="#rc.VTResult.getFailures()#" index="failure">
					<li>#failure.Message#</li>
				</cfloop>
			</ul>
		</div>
	<cfelse>
		<div align="left" style="margin-top:10px;border:1px solid black;background:##fffff0;padding:10px">
		 Enter a new user information below and Transfer will create a new record.<br /><br />
		 <strong>Demo Note: </strong>To demonstrate VT's server-side validations, no client-side validations have been generated for this form.
		</div>
	</cfif>

	#renderView('tags/menu',true,10)#

	<div style="margin-top:50px;clear:both" align="left">
		<form name="addform" id="addform" action="#event.buildLink('users.doAdd')#" method="post">
		<table width="100%" cellpadding="5" cellspacing="1" style="border:1px solid ##cccccc;">

			<tr>
				<td width="20" align="right" bgcolor="##eaeaea"><strong>First Name:</strong></td>
				<td width="100"><input type="text" name="fname" id="fname" size="50"></td>
			</tr>

			<tr>
				<td width="20"  align="right" bgcolor="##eaeaea"><strong>Last Name:</strong></td>
				<td width="100"><input type="text" name="lname" id="lname" size="50"></td>
			</tr>

			<tr>
				<td width="20"  align="right" bgcolor="##eaeaea"><strong>Email:</strong></td>
				<td width="100"><input type="text" name="email" id="email" size="50"></td>
			</tr>
		</table>

		<div style="margin-top:20px" align="center" >
			<a class="action silver" href="javascript:document.addform.submit()">
				<span>Submit</span>
			</a>
		</div>
	</form>
	</div>

</div>
</cfoutput>