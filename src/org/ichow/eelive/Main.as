package org.ichow.eelive {
	
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.SWFLoader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	import flash.text.StyleSheet;
	import org.ichow.eelive.managers.FormManager;
	import org.ichow.eelive.managers.SparkManager;
	import org.ichow.eelive.managers.VCardManager;
	import org.ichow.eelive.utils.ChatStyle;
	import org.ichow.eelive.forms.*;

	/**
	 * ...
	 * @author ...
	 */
	
	public class Main extends Sprite {
		
		public static const VERSION:String = "2.012.1";
		
		private static var _config:Object;
		private static var def_config:Object = {
			autologin: "false", 
			password: "iccc", 
			username: "iccc", 
			server: "172.16.146.109", 
			domain: "openfire.tt.gzedu.com", 
			port: "5222", 
			location: "", 
			useexternalauth: false, 
			connectiontype: "def", 
			red: "1", 
			blue: "1", 
			green: "1", 
			resource: "eelive"};

		private var _forms:Object;

		private var _xml:XML;
		private var _headXML:XML;
		private var _skin:SWFLoader;
		private var _css:StyleSheet;

		private var canvas:Sprite;

		public function Main(){
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		/**
		 * 初始化
		 * @param	e
		 */
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//get parameters
			if (stage.loaderInfo.parameters != null){
				var obj:Object = stage.loaderInfo.parameters;
				Main._config = obj;
			}

			//load config xml
			LoaderMax.activate([CSSLoader, SWFLoader, XMLLoader,ImageLoader]);

			canvas = new Sprite();
			addChild(canvas);
			
			trace("canvas: "+canvas);
			/*_progress = new ProgressBar(canvas);
			_progress.move((canvas.width - _progress.width) / -2, (canvas.height - _progress.height) / -2);
			_progress.value = 0;
			_percent = new Label(canvas);
			_percent.move((_progress.x + _progress.width + 20), _progress.y);
			_percent.text = "0%";*/

			var url:String = "assets/xml/config.xml";
			var l:XMLLoader = new XMLLoader(url, {name: "config", onComplete: onConfigComplete, onProgress: onConfigProgress});
			l.load(true);

			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		/**
		 * 屏幕变化
		 * @param	e
		 */
		private function onResize(e:Event = null):void {
			var w:int = Math.floor(stage.stageWidth);
			var h:int = Math.floor(stage.stageHeight);
			canvas.graphics.clear();
			canvas.graphics.beginFill(0xFFFFFF, .2);
			canvas.graphics.drawRect(w / -2, h / -2, w, h);
			canvas.graphics.endFill();
		}
		/**
		 * 加载条
		 * @param	e
		 */
		private function onConfigProgress(e:LoaderEvent):void {
			//var l:DataLoader = e.target as DataLoader;
			//_progress.value = l.progress;
			//var s:String = l.progress * 100 + "";
			//_percent.text = s.substr(0, 2) + "%";
		}
		/**
		 * 初始化窗口
		 */
		private function initForms():void {
			//canvas.removeChild(_progress);
			//canvas.removeChild(_percent);

			///Style.embedFonts = false;
			//Style.fontName = "宋体";
			//Style.fontSize = 12

			_forms = new Object();

			SparkManager.configProvider = _configProvider;
			FormManager.init(canvas, _xml);

			ChatStyle.instance.setFormat("system", {text: "$content", head: "【系统】"});
			ChatStyle.instance.setFormat("chat", {text: "$self  $time $content", head: ""});
		}

		/**
		 * 素材加载完成
		 * @param	e
		 */
		private function onConfigComplete(e:LoaderEvent):void {
			//composition
			_xml = new XML(LoaderMax.getContent("config").composition);
			//skin swf
			_skin = LoaderMax.getLoader("skinSWF");
			//skin css
			_css = LoaderMax.getContent("skinCSS");
			//
			_headXML = new XML(LoaderMax.getContent("head"));
			VCardManager.instance.initHead(_headXML);
			
			Style.cssStyle = _css;
			//Style.loadCSS
			trace(Style.cssStyle);
			Style.loadSkin("assets/swf/skin.swf", initForms);
			//initForms();
		}

		/**
		 * 获取配置属性
		 * @param	key
		 * @return
		 */
		private function _configProvider(key:String):String {
			return _config[key] != null ? _config[key] : def_config[key];
		}

	}

}