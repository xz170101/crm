 
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>用户列表</title>
		<link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.3/themes/icon.css">
   		<link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.3/themes/metro/easyui.css">
   		<link rel="stylesheet" type="text/css" href="js/assets/css/jquery.range.css">
    	<script type="text/javascript" src="js/jquery-easyui-1.4.3/jquery.min.js"></script>
    	<script type="text/javascript" src="js/jquery-easyui-1.4.3/jquery.range.js"></script>
    	<script type="text/javascript" src="js/jquery-easyui-1.4.3/jquery.easyui.min.js"></script>
    	<script type="text/javascript" src="js/jquery-easyui-1.4.3/locale/easyui-lang-zh_CN.js"></script>
 <script type="text/javascript">
	$(function() {// 初始化内容
		 init();
	});  
	function init() { //显示加载数据表格
		var startTime=$("#startdate").datetimebox("getValue").trim();
		var endTime=$("#enddate").datetimebox("getValue").trim();
		  if(startTime!=null && startTime!="" && endTime!=null && endTime!=""){
	            var oDate1 = new Date(startTime);
	            var oDate2 = new Date(endTime);
	            if(oDate1.getTime() > oDate2.getTime()){
	            	$("#baruser").form("reset");
	            	$.messager.alert("提示","创建开始时间不能大于结束时间！");
	                return false;
	            }
	        } 
			$("#userDG").datagrid({ 
				 	url:"selectUser",  //数据接口的地址
				 	method:'post',
			        fitColumns:true,
			        pagination:true,
			        rownumbers:true,
			        singleSelect:true,
			        toolbar:'#usertb'  ,
			        queryParams: { //要发送的参数列表
			        	text1:$("#ord").combobox("getValue").trim(),
			        	text2: $("#userName").textbox("getValue").trim(), 
			        	text3:startTime,
			        	text4:endTime,
			        	text5: $("#lock").combobox("getValue").trim()
					   }  
			   });
			$("#baruser").form("reset");
	}
	//头像
	function formatterImg(value,row,index){
		return "<img src='img/"+value+"' style='width:25px; height: 25px;'> ";
	}
	//操作列
	function formatterCaoZuo(value,row,index){
		return "<a href='javascript:void(0);'  onclick='updateInfo(" + index + ")'>编辑</a>  <a href='javascript:void(0);' onclick='delInfo(" + index + ")'>删除</a> "
	}
	//设置角色操作列
	 function formatterJueSe(value,row,index){
		return "<a href='javascript:void(0);'  onclick='SetRole(" + index + ")'>设置</a> "
	}
	//重置密码操作列
	function formatterPassword(value,row,index){
		return "<a href='javascript:void(0);'  onclick='SetPassword(" + index + ")'>重置密码</a> "
	}
	//锁定&解锁用户操作列
	function formatterYHCaoZuo(value,row,index){
		return "<a href='javascript:void(0);'  onclick='LockUser(" + index + ")'>锁定用户</a> <a href='javascript:void(0);' onclick='UnLockUser(" + index + ")'>解锁用户</a>"
	} 
	function formatterisLockout(value,row,index){
		// return  row.isLockout==0?'未锁定':'已锁定' ;
		if(row.isLockout == 0){ return '未锁定'; }else{return '已锁定';}  
	}

	//设置角色
	var row=null;
	function SetRole(index){
		$("#setRolse_window").window('open');
		var data=$("#userDG").datagrid("getData");
		 row=data.rows[index];
		$("#setRolse_window").dialog("setTitle","您正在设置"+row.loginName+"的角色信息");
		//查询所有角色
		$("#allRole").datagrid({
				url:"selectRole_user",  
		        rownumbers:true,
		        singleSelect:true 
	   });
		//查询该用户具有的角色
		 $("#myRole").datagrid({ 
	    		url:"selectUserRole",   
		        rownumbers:true,
		        singleSelect:true,
		        queryParams: {  
		        	user_Id: row.user_Id
	        }
		   });
		}
	  //添加用户角色
 	   function SetRoleAdd(){
		   	var RoleRow=$("#allRole").datagrid("getSelected");
		   	if(RoleRow){
			        $.post("addUserRole",{
			      		userId: row.user_Id,
			      		roleId: RoleRow.roles_Id 
			   		},function(res){
			   			if(res>0){
			   				$("#myRole").datagrid("reload");
			   			}else{
			   				$.messager.alert("提示","已存在");
			   			}
			   		},"json");
	   		}else{
	   			$.messager.alert("提示","请先选择对象!");
	   		}
	   }
	 //移除用户角色
 	 function SetRoleRemove(){
 		var RoleRow=$("#myRole").datagrid("getSelected");
 		if(RoleRow){
	      	 $.post("delUserRole",{
	      		userId: row.user_Id,
	      		roleId: RoleRow.roles_Id 
		   		},function(res){
		   			if(res>0){
		   				$("#myRole").datagrid("reload");
		   			}
		   		},"json");
	   		}else{
	   			$.messager.alert("提示","请先选择对象!");
	   		}
		 }
 	//锁定用户
	function LockUser(index){
		$.messager.confirm('确认','您确认想要锁定用户吗？',function(r){   
    		if (r){ // 用户点击了确认按钮 执行删除    
 				var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
	            var row = data.rows[index]; //获取第index行对应的json对象
	            $.post("lockUser",
                    {
                        user_Id:row.user_Id,
                    },function(res){
                        if(res>0){
                        	$("#userDG").datagrid("reload");
	                        $.messager.alert("系统提示！","锁定成功！");
                        }
                    });   
 				 }   
			});
	}
	//解锁用户
	function UnLockUser(index){
		$.messager.confirm('确认','您确认想要解锁用户吗？',function(r){   
    		if (r){ // 用户点击了确认按钮 执行删除    
 				var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
	            var row = data.rows[index]; //获取第index行对应的json对象
	            $.post("unLockUser",
                    {
                        user_Id:row.user_Id,
                    },function(res){
                        if(res>0){
                        	$("#userDG").datagrid("reload");
	                        $.messager.alert("系统提示！","解锁成功");
                        }
                    });   
 				 }   
			});
	}
	//重置密码
	function SetPassword(index){
		var data=$("#userDG").datagrid("getData");
		var row=data.rows[index];
		$.messager.confirm('确认','您确认重置用户密码吗？',function(r){   
		 if (r){ 
			$.post("resetPassword",{
				loginName:row.loginName,
		   		},function(res){
		   			if(res>0){
		   				$("#userDG").datagrid("reload");
		   				$.messager.alert("提示","重置密码成功！");
		   			}else{
		   				$.messager.alert("提示",res.message);
		   			}
		   		},"json");
		   }
		 }); 
	}
	
	//点击新增按钮
    function addInfo(){
        $("#adduser_window").dialog("open");
    }
    //取消新增
    function closeUserForm(){
    	$("#adduserForm").form("clear");
    	$("#adduser_window").dialog("close");
    	$("#edituserForm").form("clear");
    	$("#edituser_window").dialog("close");
    }
   //修改用户信息
 	   function updateInfo(index){
 			var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
            var row = data.rows[index]; //获取第index行对应的json对象
           	$("#edituserForm").form("load",row); //使用form的load方法，快速将json对象的数据显示到 弹出窗口的表单元素之中。
            $("#edituser_window").dialog("open");//打开窗口  
 		}
 		//提交修改
 		function submitUserEditForm(){
 			var flag=$("#edituserForm").form("validate");
 			var userid=$("#userid").val();
 			var ename=$("#eename").val();
 			var email=$("#eemail").val();
 			var etel=$("#metel").val();
 			if(flag){
	 			if(!(/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/.test(email))){
					 $.messager.alert("提示","邮箱格式有误，请重新输入！");
		                return false;
		            }
	 			if(!(/^(13|14|15|17|18)\d{9}$/.test(etel))){
	 				 $.messager.alert("提示","手机号码格式有误，请重新输入！");
		                return false;
		         } else{
		        	 $.ajax({
		 				url:"selectUserByTel",
		 				method:'post',
		 				data:{"protectMTel":etel},
		 				dataType:'json',
		 				success:function(data){
		 					 	if(data>0){
		 					 		$.messager.alert("提示","一个手机号只能绑定一个用户<br/>请重新输入手机号！");
		 							return false;
		 						}else{
		 							$.post("updateUser",{
		 								protectEMail:email,
		 			                    protectMTel:etel,
		 								loginName:ename,
		 			 					user_Id:userid
		 			                 },function(res){
		 			                     if(res>0){
		 			                      	$("#userDG").datagrid("reload");
		 			                      	closeUserForm();
		 			                        $.messager.alert("提示！","修改成功！");
		 			                     }
		 			                 },"json");
		 						}   
		 					}
		 				});
		 			}  
	 			}
	 		}  
		//删除
		function delInfo(index){
			$.messager.confirm('确认','您确认想要删除用户吗？',function(r){   
    		if (r){ // 用户点击了确认按钮 执行删除    
 				var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
	            var row = data.rows[index]; //获取第index行对应的json对象
	            $.post("delUser", {
                        user_Id:row.user_Id,
                    },function(res){
                         if(res>0){
                        	$("#userDG").datagrid("reload");
	                        $.messager.alert("提示！","删除成功");
                        }else{
                        	$.messager.alert("提示！","该用户具有角色不可删除!");
                        }
                    });   
 				 }   
			});
		}
		 
	</script>
</head>
<body>
	<table name="center" class="easyui-datagrid" id="userDG" title="用户列表" style="width:300;height:400"  >
	    <thead>
	        <tr>
             	<th data-options="field:'user_Id',hidden:true">用户ID</th>
	             <th data-options="field:'loginName'">用户名</th>
	             <th data-options="field:'uexit2String',formatter:formatterImg">头像</th>
	             <th data-options="field:'protectEMail'">邮箱</th>
	             <th data-options="field:'protectMTel'">手机号</th>
	             <th data-options="field:'isLockout',formatter:formatterisLockout">是否锁定</th>
	             <th data-options="field:'createTime'">创建时间</th>
	             <th data-options="field:'loginTime'">最后登录的时间</th>
	             <th data-options="field:'JueSe',formatter:formatterJueSe">角色</th>
	             <th data-options="field:'YHCaoZuo',formatter:formatterYHCaoZuo">用户操作</th>
	             <th data-options="field:'Password',formatter:formatterPassword">操作</th>
	             <th data-options="field:'caozuo', formatter:formatterCaoZuo" >操作</th>
 	    	</tr>
	    </thead>
	</table>
	<!-- 搜素框 -->
	<div id="usertb" style="padding:5px; height:auto">
 		    <form id="baruser"  class="easyui-form">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addInfo()">新增</a>&nbsp;&nbsp;&nbsp;&nbsp;
		        	用户名: <input class="easyui-textbox" id="userName" style="width:80px">
		        	创建起止时间：<input class="easyui-datetimebox" data-options="editable:false" id="startdate" style="width:100px">~
		        			<input  class="easyui-datetimebox" data-options="editable:false" id="enddate" style="width:100px">
		        			
		        	是否锁定：<select id="lock" class="easyui-combobox" name="lock" data-options="panelHeight:'auto'" editable="false">
							    <option value="">-请选择-</option>
							    <option value="1"> 已锁定</option>
							    <option value="0"> 未锁定</option>
							  </select>
		        	排   序：<select id="ord" class="easyui-combobox" name="orderBy" data-options="panelHeight:'auto'"  editable="false" >
						    <option value="">-请选择-</option>
						    <option value="createTime">创建时间</option>
						    <option value="loginTime">最后登录时间</option>
						   </select>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="init()">查找</a>
		    </form>
		 </div>
	 
<script type="text/javascript">
//对新增表单的验证
	function vnewusername() {//验证用户名是否存在
		var name=$("#newusername").val().trim();
 		if(name!=''){
			$.ajax({
				url:"selectUserByName",
				method:'post',
				data:{"loginName":name},
				dataType:'json',
				success:function(data){
						if(data>0){
							$("#yznewusername").html('用户名已存在！');
 	 						document.getElementById('yznewusername').style.color = 'red';
							return false;
						}else{
							$("#yznewusername").html(' ');
							return true;
						}
					}
				});
			}else{
				$("#yznewusername").html('用户名不能为空！');
 				document.getElementById('yznewusername').style.color = 'red';
			}
	}
	function vuserpwd() {
		return vRegexp('userpwd',/^[a-z0-9]{6,12}$/);
	}
	function vreuserpwd() {
 		 var pwd=$("#userpwd").val().trim();
		 var repwd=$("#reuserpwd").val().trim();
		if(pwd!=repwd){
			$("#yzreuserpwd").html('两次密码不一致！');
 			document.getElementById('yznewusername').style.color = 'red';
			return false;
		}
		return vRegexp('reuserpwd',/^[a-z0-9]{6,12}$/);
	}
	function vusertel() {
 		var tel=$("#usertel").val();
		var telRegexp= /^1[34578]\d{9}$/.test(tel) ;
		  if(telRegexp){
			  $("#yzusertel").html('');
			$.ajax({
				url:"selectUserByTel",
				method:'post',
				data:{"protectMTel":tel},
				dataType:'json',
				success:function(data){
					 	if(data>0){
					 		$("#yzusertel").html('一个手机号只能绑定一个用户！');
 	 						document.getElementById('yzusertel').style.color = 'red';
							return false;
						}else{
							$("#yzusertel").html(' ');
							return true;
						}   
					}
				});
		  	}else{
		  		$("#yzusertel").html('您的输入不合法！');
 				document.getElementById('yzusertel').style.color = 'red';
			}
		} 
 
	function vuseremail() {
		return vRegexp('useremail',/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/);
	}
	//验证不为空
	function  vNull(name) {
		 var elem = document.getElementById(name);
		 var msg = document.getElementById('yz'+name);
		 if (elem.value == '' || elem.value == ' ') {
		    msg.innerHTML = '* 您的输入不能为空';
		    msg.style.color = 'red';
		    return false;
		  } else {
		    msg.innerHTML = ' ';
		    return true;
		  }
	}
	//验证Regexp
	function vRegexp(name,regexp) {
		var elem = document.getElementById(name);
		var msg = document.getElementById('yz'+name)
		if (regexp.test(elem.value)) {
		    msg.innerHTML = ' ';
		    return true;
		  } else {
		    msg.innerHTML = '您的输入不合法';
		    msg.style.color = 'red';
		    return false;
		  }
	}
	function submitUserForm(){
		 var name=$("#newusername").val().trim();
		 var pwd=$("#userpwd").val().trim();
 		 var tel=$("#usertel").val().trim();
		 var email=$("#useremail").val().trim();
		 var flag=$("#adduserForm").form("validate");
		 if(pwd !=null && pwd !=""){
			 if(tel !=null && tel !=""){
				 if(email !=null && email !=""){
					   $.post("newUser", {    
			        		loginName:name,
			                passWord:pwd,
			                protectEMail:email,
			                protectMTel:tel 
			            }, function(res){
			                if(res>0){
			                	closeUserForm();
			                    $("#userDG").datagrid("reload"); //通过调用reload方法，让datagrid刷新显示数据
			               		$.messager.alert("提示!","新增成功！");
			                }
			        },"json");  
				 }else{
					 $.messager.alert("提示!","密保邮箱不能为空！");
				 }
			 }else{
				 $.messager.alert("提示!","密保手机号不能为空！");
			 }
		 }else{
			 $.messager.alert("提示!","密码不能为空！");
		 }
 			//if(vnewusername()){
				// if(vusertel()){
					 
				// }else{
				//	 $.messager.alert("提示!","一个手机号只能绑定一个用户！");
				// }
		/// }else{
		//	 $.messager.alert("提示!","用户名已存在！");
		 //}
	}
	 
</script>
		<!-- 新增面板 -->
		<div id="adduser_window" class="easyui-dialog" title="新增用户信息" data-options="modal:true,closed:true,iconCls:'icon-save',buttons:[{
								text:'保存',
								handler:function(){ submitUserForm();}
							},{
								text:'关闭',
								handler:function(){ closeUserForm();}
							}]" style="width:600px;height:350px;padding:10px;">
         	<form id="adduserForm">
                <table cellpadding="5">
                    <tr>
                        <td>用户名:</td>
                        <td><input onblur="vnewusername()" type="text" name="name"  id="newusername" data-options="required:true"></input></td>
                    	<td><span id="yznewusername"></span></td>
                    	<td></td>
                    </tr>
                    <tr>
                        <td>密码:</td>
                        <td><input onkeyup="vuserpwd()" type="password" id="userpwd" name="pwd" data-options="required:true"></input></td>
                   		<td><span id="yzuserpwd">由6-12位数字或字母组成</span></td>
                   		<td> </td>
                    </tr>
                    <tr>
                        <td>确认密码:</td>
                        <td><input onkeyup="vreuserpwd()"   type="password" id="reuserpwd" name="pwd" data-options="required:true"></input></td>
                   		<td><span id="yzreuserpwd"></span></td>
                   		<td></td>
                    </tr>
                    <tr>
                        <td>手机号:</td>
                        <td><input onkeyup="vusertel()" type="text"   id="usertel"  name="protectMTel" data-options="required:true"></td>
                    	<td><span id="yzusertel"></span></td>
                    	<td></td>
                    </tr>       
                    <tr>
                        <td>Email:</td>
                        <td><input onkeyup="vuseremail()"   type="text" id="useremail" name="email" data-options="required:true,validType:'email'"></input></td>
                    	<td><span id="yzuseremail"></span></td>
                    	<td></td>
                    </tr>
                </table>
        	 </form>
    	</div>
	<!-- 修改用户 -->
	  <div id="edituser_window" class="easyui-dialog" title="修改员工信息" data-options="modal:true,closed:true,iconCls:'icon-save',buttons:[{
								text:'保存',
								handler:function(){ submitUserEditForm();}
							},{
								text:'关闭',
								handler:function(){ closeUserForm();}
							}]" style="width:350px;height:300px;padding:10px;">
         <form id="edituserForm">
            <table cellpadding="5">
            	<tr>
                    <td> </td>
                    <td><input  type="hidden" name="user_Id" id="userid"  /></td>
               		<td><span ></span></td>
                </tr>
                <tr>
                    <td>用户名:</td>
                    <td><input class="easyui-textbox" type="text" readonly name="loginName" id="eename"  ></input></td>
                	<td><span></span></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input class="easyui-textbox" type="text" name="protectEMail" id="eemail" data-options="required:true,validType:'email'"></input></td>
                	<td><span id="editEmail"></span></td>
                </tr>
                <tr>
                    <td>手机号:</td>
                    <td><input type="text"  class="easyui-numberbox" name="protectMTel" id="metel" data-options="required:true"></td>
               		<td><span id="musertel"></span></td>
                </tr>                    
            </table>
         </form>
	</div>  
	<!--设置用户-->
	<div id="setRolse_window" class="easyui-window" data-options="modal:true,closed:true" >
		<table   style="width:330px;height:500px;">
				<tr valign="top">
					<td>
						<table  id="allRole" title="系统所有角色" class="easyui-datagrid">
							<thead>
								<th data-options="field:'roles_Id',width:280,hidden:true">用户ID</th>
		             			<th data-options="field:'roles_Name',width:100">用户名</th>
							</thead>
						</table>
					</td>
					<td>
						<input id="addRole" type="button" onclick="SetRoleAdd()"  value="》》" /><br/>
						<input id="removeRole" type="button" onclick="SetRoleRemove()" value="《《" />
					</td>
					<td>
						<table id="myRole" title="当前用户的角色" class="easyui-datagrid">
							<thead>
								<th data-options="field:'roles_Id',width:280,hidden:true">用户ID</th>
		             			<th data-options="field:'roles_Name',width:100">用户名</th>
							</thead>
						</table>
					</td>
				</tr>
		</table>			
	</div>


</body>
 
</html>