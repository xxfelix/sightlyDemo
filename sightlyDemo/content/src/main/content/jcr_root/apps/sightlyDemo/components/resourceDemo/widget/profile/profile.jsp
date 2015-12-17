
<%@include file="/libs/granite/ui/global.jsp"%>
<%
%><%@page session="false"
	import="com.adobe.granite.ui.components.AttrBuilder,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.ComponentHelper,
                  com.adobe.granite.ui.components.Tag,
                  java.io.IOException,
                  java.util.List,
                  java.util.Map,
                  java.net.MalformedURLException,
                  java.net.URL,
                  java.io.IOException,
                  java.util.HashMap,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.Field,
                  javax.jcr.Node"%>
<%
	Config cfg = cmp.getConfig();
	String name = cfg.get("name", String.class);
	String[] value = cmp.getValue().get(name, new String[0]);
	ValueMap vm = new ValueMapDecorator(new HashMap<String, Object>());
	vm.put("value", value);

	try {

    String fieldLabel = cfg.get("fieldLabel", String.class);
    		
     Tag tag = cmp.consumeTag();
     AttrBuilder attrs = tag.getAttrs();
     attrs.addClass(cfg.get("class", String.class));
     attrs.add("title", i18n.getVar(cfg.get("title", String.class)));

     attrs.addClass("coral-Select");
     attrs.addClass("coral-Form-field");
     attrs.add("data-init", "select");

     AttrBuilder buttonAttrs = new AttrBuilder(request, xssAPI);
     buttonAttrs.add("type", "button");
	 buttonAttrs.addClass("coral-Select-button coral-MinimalButton");


     AttrBuilder selectAttrs = new AttrBuilder(request, xssAPI);
     selectAttrs.add("name", cfg.get("name", String.class));
     selectAttrs.addMultiple(false);
 	 selectAttrs.addDisabled(false);
     selectAttrs.addClass("coral-Select-select");

     AttrBuilder selectListAttrs = new AttrBuilder(request, xssAPI);
     selectListAttrs.addOther("collision-adjustment", cfg.get("collisionAdjustment", String.class));

     String requestURL = request.getRequestURL().toString();
 	 String cutURL = requestURL.split("_cq_dialog.html")[1];
     log.info("jsjs:"+cutURL);
     
     Resource res= resourceResolver.getResource(cutURL);
     Node node = res.adaptTo(Node.class);
     String nameProp = (name == null)? "" : name.replace("./","");
     String profileVal= (node.hasProperty(nameProp))? node.getProperty(nameProp).getValue().getString() : "";
     log.info("test:"+profileVal);
 %>
<div class="coral-Form-fieldwrapper">
<label class="coral-Form-fieldlabel"><%=fieldLabel %></label>
<span <%= attrs.build() %>>

	<button <%= buttonAttrs.build() %>>
	 	<div class="coral-Wait" style="margin-left: 4%;" selectwait></div>
		<span class="coral-Select-button-text" selectButton></span>
	</button> 
	<select <%= selectAttrs.build() %> selectlist>
	        </select>
		<ul class="coral-SelectList" <%= selectListAttrs.build() %> selectlistul>

    </ul>
</span> 
</div>
<script>
var profileVal = "<%=profileVal%>";
$.getJSON("/etc/dam/video.profiles.list.json", function(jsonResult) {
	$("div[selectwait]").hide();
	$("select[selectlist] option").remove(); 
	$.each(jsonResult, function(index) {
		var text = this.text?this.text:this.value;
		var value = this.value;
		$("select[selectlist]").append('<option value="'+ value +'"'+ ((value === profileVal)?' selected=selected':'') +'>'+ text +'</option>'); 
        $("ul[selectlistul]").append('<li class="coral-SelectList-item coral-SelectList-item--option is-highlighted" data-value="'+value+'" role="option"aria-selected="'+(value === profileVal)+'"  tabindex="0">'+text+'</li>');
		if(profileVal == value){
			profileVal = text;
		}
	});
	$("span[selectButton]").html(profileVal);
});
</script>
<%
	} catch (MalformedURLException e) {
		log.error("error jsp" + e.getMessage());
		   e.printStackTrace();
	} catch (Exception e) {
		log.error("error jsp2" + e.getMessage());
		e.printStackTrace();
	}
%>

