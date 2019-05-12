<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>用户列表</title>
<link rel="stylesheet" type="text/css" href="../js/jquery-easyui-1.4.3/themes/icon.css">
   		<link rel="stylesheet" type="text/css" href="../js/jquery-easyui-1.4.3/themes/metro/easyui.css">
    	<script type="text/javascript" src="../js/jquery-easyui-1.4.3/jquery.min.js"></script>
    	<script type="text/javascript" src="../js/jquery-easyui-1.4.3/jquery.easyui.min.js"></script>
    	<script type="text/javascript" src="../js/jquery-easyui-1.4.3/locale/easyui-lang-zh_CN.js"></script>
 <script type="text/javascript">
	$(function() {// 初始化内容
			init();
	});  
	function init() { //显示加载数据表格
			$("#userDG").datagrid({ 
				 	url:"../selectUser",  //数据接口的地址
				 	method:'post',
			        fitColumns:true,
			        pagination:true,
			        rownumbers:true,
			        singleSelect:true,
			        toolbar:'#usertb'  ,
			        queryParams: { //要发送的参数列表
			        	text1:$("#ord").combobox("getValue"),
			        	text2: $("#userName").textbox("getValue"), 
			        	text3:$("#startdate").datetimebox("getValue"),
			        	text4:$("#enddate").datetimebox("getValue"),
			        	text5: $("#lock").combobox("getValue")
					   }  
			   });
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
		// return  row.isLockout=0?'未锁定':'已锁定' ;
		if(row.isLockout == 0){ return '未锁定'; }else{return '已锁定';}  
	}
	//锁定用户
	function LockUser(index){
		$.messager.confirm('确认','您确认想要锁定用户吗？',function(r){   
    		if (r){ // 用户点击了确认按钮 执行删除    
 				var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
	            var row = data.rows[index]; //获取第index行对应的json对象
	            $.post("../lockUser",
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
	            $.post("../unLockUser",
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
			$.post("../resetPassword",{
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
    	$("#adduser_window").dialog("close");
    	$("#edituser_window").dialog("close");
    }
	//点击新增窗体保存按钮
         function submitUserForm(){
        	//validate-->验证文本框中的内容是否有效
            var flag=$("#adduserForm").form("validate");
          /*验证用户名是否重复 
          $("#ename").change(function(){ 
            	var loginName = this.value; 
            	$.ajax({ 
            		url:"../checkLoginName", 
            		data:"loginName="+loginName, 
            		type:"POST", 
            		success:function(data){ 
            			if(data=="1"){ 
            				show_validate_msg("#ename","success","学院名可用"); 
            				$("#xueyuan_save_btn").attr("ajax-va","success"); 
            				}else { 
            					show_validate_msg("#ename","error","学院名重复"); 
            					$("#xueyuan_save_btn").attr("ajax-va","error"); 
            					} 
            			} 
            		}); 
            	}); */
            var ename=$("#ename").val();
            var pwd=$("#pwd").val();
            var email=$("#email").val();
            var mtel=$("#mtel").val();
	            if(!(/^(13|15|17|18)\d{9}$/.test(mtel))){
	                alert("手机号码格式有误，请重新输入！");
	                return false;
	            }
            if(flag){
                $.post("../addUser", {    
                		loginName:ename,
                        passWord:pwd,
                        protectEMail:email,
                        protectMTel:mtel 
                    }, function(res){
                        if(res>0){
                        	closeUserForm();
                            $("#userDG").datagrid("reload"); //通过调用reload方法，让datagrid刷新显示数据
                       		$.messager.alert("提示!","新增成功！");
                        }
                },"json");
            }    
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
 			 
 			 if(!(/^(13|15|17|18)\d{9}$/.test(etel))){
	                alert("手机号码格式有误，请重新输入！");
	                return false;
	            }
 			if(flag){
	 			$.post("../updateUser",{
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
	//删除
		function delInfo(index){
			$.messager.confirm('确认','您确认想要删除用户吗？',function(r){   
    		if (r){ // 用户点击了确认按钮 执行删除    
 				var data = $("#userDG").datagrid("getData"); //获取datagrid对应的json对象集合  
	            var row = data.rows[index]; //获取第index行对应的json对象
	            $.post("../delUser",
                    {
                        user_Id:row.user_Id,
                    },function(res){
                        if(res>0){
                        	$("#userDG").datagrid("reload");
	                        $.messager.alert("提示！","删除成功");
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
             	<th data-options="field:'user_Id',width:280,hidden:true">用户ID</th>
	             <th data-options="field:'loginName',width:100">用户名</th>
	             <th data-options="field:'protectEMail',width:100">邮箱</th>
	             <th data-options="field:'protectMTel',width:100,">手机号</th>
	             <th data-options="field:'isLockout',width:100,formatter:formatterisLockout">是否锁定</th>
	             <th data-options="field:'createTime',width:160,">创建时间</th>
	             <th data-options="field:'loginTime',width:160,">最后登录的时间</th>
	             <th data-options="field:'JueSe',width:80,formatter:formatterJueSe">角色</th>
	             <th data-options="field:'YHCaoZuo',width:100,formatter:formatterYHCaoZuo">用户操作</th>
	             <th data-options="field:'Password',width:100,formatter:formatterPassword">操作</th>
	             <th data-options="field:'caozuo',width:160, formatter:formatterCaoZuo" >操作</th>
 	    	</tr>
	    </thead>
	</table>
	<!-- 搜素框 -->
	<div id="usertb" style="padding:5px; height:auto">
		    <div style="margin-bottom:5px">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addInfo()">新增</a>&nbsp;&nbsp;&nbsp;&nbsp;
		        	用户名: <input class="easyui-textbox" id="userName" style="width:80px">
		        	起止时间：<input class="easyui-datetimebox" id="startdate" style="width:100px">-
		        			<input class="easyui-datetimebox" id="enddate" style="width:100px">
		        	是否锁定：<select id="lock" class="easyui-combobox" name="lock" data-options="panelHeight:'auto'" >
							    <option value="">-请选择-</option>
							    <option value="1"> 是</option>
							    <option value="0"> 否</option>
							  </select>
		        	排   序：<select id="ord" class="easyui-combobox" name="orderBy" data-options="panelHeight:'auto'" >
						    <option value="">-请选择-</option>
						    <option value="createTime">创建时间</option>
						    <option value="loginTime">最后登录时间</option>
						   </select>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="init()">查找</a>
		    </div>
		</div>
		<!-- 新增面板 -->
		<div id="adduser_window" class="easyui-dialog" title="新增用户信息" data-options="modal:true,closed:true,iconCls:'icon-save',buttons:[{
								text:'保存',
								handler:function(){ submitUserForm();}
							},{
								text:'关闭',
								handler:function(){ closeUserForm();}
							}]" style="width:350px;height:300px;padding:10px;">
         	<form id="adduserForm">
                <table cellpadding="5">
                    <tr>
                        <td>用户名:</td>
                        <td><input class="easyui-textbox" type="text" name="name" id="ename" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td>密码:</td>
                        <td><input class="easyui-textbox" type="password" id="pwd" name="pwd" data-options="required:true"></input></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td><input class="easyui-textbox" type="text" name="email" id="email" data-options="required:true,validType:'email'"></input></td>
                    </tr>
               
                    <tr>
                        <td>手机号:</td>
                        <td><input type="text" class="easyui-numberbox"  name="protectMTel" id="mtel" data-options="required:true"></td>
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
                    <td><input    type="hidden"   name="user_Id" id="userid"  /></td>
                </tr>
                <tr>
                    <td>用户名:</td>
                    <td><input class="easyui-textbox" type="text" readonly name="loginName" id="eename"  ></input></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input class="easyui-textbox" type="text" name="protectEMail" id="eemail" data-options="required:true,validType:'email'"></input></td>
                </tr>
                <tr>
                    <td>手机号:</td>
                    <td><input type="text" class="easyui-numberbox" name="protectMTel" id="metel" data-options="required:true"></td>
                </tr>                    
            </table>
         </form>
	</div>  



</body>
</html>