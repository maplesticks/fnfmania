package unused; //went unused, now a function for playstate

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;

import states.MainMenuState;
import states.FreeplayState;
import states.PlayState;

class ResultsSubState extends MusicBeatSubstate
{
	var currentMusic:FlxSound;
	var scoreText:FlxText;
	var totalRank:FlxText;
	var totalOtherRank:FlxText;

	public static var songName:String = '';

	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var songInfo:FlxText = new FlxText(20, 15, 0, PlayState.SONG.song + ' [' + Difficulty.getString().toUpperCase() + ']', 32);
		songInfo.scrollFactor.set();
		songInfo.setFormat(Paths.font("pm-full.ttf"), 32);
		songInfo.updateHitbox();
		songInfo.screenCenter(X);
		add(songInfo);


		var totalRank:FlxText = new FlxText(900, 15, '', 64);
		totalRank.scrollFactor.set();
		totalRank.setFormat(Paths.font("pm-full.ttf"), 64);
		totalRank.updateHitbox();
		totalRank.screenCenter(Y);
		add(totalRank);

//		totalRank = PlayState.ratingName;

		songInfo.alpha = 0;

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(songInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (accepted)
		{
			MusicBeatState.switchState(new FreeplayState());
		}
	}
}
