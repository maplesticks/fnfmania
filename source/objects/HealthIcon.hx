package objects;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public var canBop:Bool = false;
	public var playbackRate:Float = 1;
    public var bopType = 'Normal';
    public var rythm:Bool = true;

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, allowGPU);
		scrollFactor.set();
		antialiasing = ClientPrefs.data.antialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			if(!Paths.fileExists('images/' + name + '.png', IMAGE) && name == 'icons/') name = 'icons/icon-unknow';

			var graphic = Paths.image(name, allowGPU);

			loadGraphic(graphic); //Load stupidly first for getting the file size
			var heads:Int = 2;
			if(width == 150){heads = 1;}
			if(width == 300){heads = 2;}
			if(width == 450){heads = 3;}

			loadGraphic(graphic, true, Math.floor(graphic.width / heads), Math.floor(graphic.height));
			iconOffsets[0] = (width - 150) / heads;
			iconOffsets[1] = (width - 150) / heads;
			updateHitbox();

			var iconFrames:Array<Int> = [];
			var i:Int = 0;
			while(i + 1 <= heads){
				iconFrames.push(i);
				i++;
			}

			animation.add(char, iconFrames, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
	public function dance(elapsed:Float)
	{	
		if(!canBop) return;
		if(states.PlayState.instance == null) playbackRate = 1;
		else playbackRate = states.PlayState.instance.playbackRate;

		switch(bopType.toLowerCase()){
			case 'none':
				return;
			case 'normal':
				var mult:Float = FlxMath.lerp(1, this.scale.x, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
				this.scale.set(mult, mult);
			case 'reversed':
				var mult:Float = FlxMath.lerp(0.8, this.scale.x, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
				this.scale.set(mult, mult);
			case 'sus':
				var mult:Float = FlxMath.lerp(1, this.scale.x, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
				this.scale.set(mult, mult);
			case 'cassete':
				return;
			case 'box':
				var mult:Float = FlxMath.lerp(1, this.scale.x, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
				this.scale.set(mult, mult);
				this.angle = FlxMath.lerp(0, this.angle, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
			case 'squish':
				var mult:Float = FlxMath.lerp(1, this.scale.y, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
				this.scale.set(1, mult);
			case 'goose':
				this.angle = FlxMath.lerp(0, this.angle, FlxMath.bound(1 - (elapsed * 9 * playbackRate), 0, 1));
		}
		this.updateHitbox();
	}

	public function beatHit()
	{
		if(!canBop) return;
		switch(bopType.toLowerCase()){
			case 'none':
				return;
			case 'normal':
				this.scale.set(1.2, 1.2);
			case 'reversed':
				this.scale.set(1, 1);
			case 'sus':
				this.scale.set(1.1, 1.1);
			case 'cassete':
				if(rythm) this.angle = 15;
				else this.angle = -15;
				if(!isPlayer) this.angle *= -1;
			case 'box':
				this.scale.set(1.2, 1.2);
				if(rythm) this.angle = 15;
				else this.angle = -15;
			case 'squish':
				this.scale.set(1, 0.6);
			case 'goose':
				if(!isPlayer) this.angle = 12;
				else this.angle = -12;
		}
		rythm = !rythm;
		this.updateHitbox();
	}

	public function clear()
	{
		this.scale.set(1, 1);
		this.angle = 0;
		this.updateHitbox();
	}
}
