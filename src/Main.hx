import haxegon.*;

class Main {

	static public function shuffle<T>(a:Array<T>) {
	        var i = a.length;
	        while(0 < i) {
	            var j = Std.random(i);
	            var t = a[--i];
	            a[i] = a[j];
	            a[j] = t;
	        }
	        return a;
	    }


	var people:Array<Array<Float>>;
	function genPeople(){
		people = new Array<Array<Float>>();
		for (i in 0...nameList.length){
			var dat:Array<Float> = [Random.float(0,1),Random.float(0,1),Random.float(0,1),Random.float(0,1),Random.float(0,1)];
			people.push(dat);
		}
	}

	var nameList:Array<String> = ["Thiago", "Benjamín", "Juan", "Santino", "Mateo", "Joaquín", "Bautista", "Santiago", "Tomás", "Felipe", "Jing", "Ying", "Yan", "Li", "Xiaoyan", "Xinyi", "Jie", "Lili", "Xiaomei", "Tingting", "Fatemeh", "Zahra", "Maryam", "Ma'soumeh", "Sakineh", "Zeinab", "Roghayyeh", "Khadije", "Leyla", "Somayyeh", "Hiro", "Teiki", "Moana", "Manua", "Marama", "Teiva", "Teva", "Maui", "Tehei", "Tamatoa", "Ioane", "Tapuarii"];	

	function new(){
		Gfx.createimage("buffer",Gfx.screenwidth,Gfx.screenheight);
		shuffle(nameList);
		genPeople();
		updateselectloverender();
	}

	function drawPerson(px:Float,py:Float,v:Array<Float>,index:Int){
		var alpha:Float = (5.0-relationshipCount)/5.0;
		if (alpha<0){
			alpha=0;
		}
		var bluecol:Int = Std.int(0x0000ff*alpha);
/*
		var params:Dynamic = {
			weight:Random.float(0,1),
			height:Random.float(0,1),
			hairlength:Random.float(0,1),//bald - hair
			pantscol: Random.float(0,1),
			jacketcol: Random.float(0,1)
		};*/
		var w:Float = 15*v[0]+10;
		var h:Float = 20*v[1]+20;
		var legr:Float = 3+3*v[0];
		var legheight:Float = 10*v[1]+10;
		var legoffset:Float = w/2;
		var headradius:Float=6;
		var armlength = h;
		var armdx = Math.sin(-Math.PI/10)*armlength;
		var armdy = Math.cos(Math.PI/10)*armlength;
		var hairsize = 10*v[2];
		var pantscol = Gfx.rgb(Math.floor(v[3]*255*alpha),Math.floor(v[3]*255*alpha),Std.int(255*alpha));
		var jacketcol = Gfx.rgb(Math.floor(v[4]*255*alpha),Math.floor(v[4]*255*alpha),Std.int(255*alpha));


		//hair
		Gfx.fillcircle(
			px,
			py-legheight-h-headradius,
			headradius+hairsize,bluecol);
		Gfx.fillcircle(
			px,
			py-legheight-h-headradius,
			headradius,Col.BLACK);
		Gfx.fillbox(
			px-headradius-1-hairsize,
			py-legheight-h-headradius,
			2*headradius+2+2*hairsize,
			headradius+1+hairsize,
			Col.BLACK);

		//left leg
		Gfx.fillbox(
			px-legoffset-legr,
			py-legheight,
			legr*2,
			legheight,pantscol);
		//right leg
		Gfx.fillbox(
			px+legoffset-legr,
			py-legheight,
			legr*2,
			legheight,pantscol);
		//torso
		Gfx.fillbox(
			px-w,
			py-legheight-h,
			2*w,
			h,jacketcol);
		//head
		Gfx.drawcircle(
			px,
			py-legheight-h-headradius,
			headradius,bluecol);

		//left arm
		Gfx.drawline(
			px-w,
			py-legheight-h,
			px-w+armdx,
			py-legheight-h+armdy,
			bluecol
			);
		//right arm
		Gfx.drawline(
			px+w,
			py-legheight-h,
			px+w-armdx,
			py-legheight-h+armdy,
			bluecol
			);


	}

	function distance(x1:Float,y1:Float,x2:Float,y2:Float):Float{
		var dx = x2-x1;
		var dy = y2-y1;
		return Math.sqrt(dx*dx+dy*dy);
	}
	var personOffset = 0;
	var selectRadius = Gfx.screenwidth/8;

/*
	0	"select love"
	1	"you love X, X IS UTTERLY UNIQUE"
	2	"BREAK UP"
	3	THE END
*/
	var state:Int=0;

	var ordinals = ["FIRST","SECOND","THIRD","FOURTH","FIFTH","SIXTH","SEVENTH","EIGHTH","NINETH","TENTH"];
	var relationshipCount:Int = 0;
	var selectedIndices:Array<Int> = [];
	var selectedlover = 0;
	function diff(a:Array<Float>,b:Array<Float>){
		return 0.2*(Math.abs(a[0]-b[0])+Math.abs(a[1]-b[1])+Math.abs(a[2]-b[2])+Math.abs(a[3]-b[3])+Math.abs(a[4]-b[4]));
	}

	function updateselectloverender(){
		Gfx.drawtoimage("buffer");
		Gfx.fillbox(0,0,Gfx.screenwidth,Gfx.screenheight,0);
		var alpha:Float = (5.0-relationshipCount)/5.0;
		if (alpha<0){
			alpha=0;
		}
		var gry = Std.int(0xff*alpha);
		var gray = Gfx.rgb(gry,gry,gry);

		var ordinal = relationshipCount<ordinals.length?ordinals[relationshipCount]:"NEXT";
		Text.display(Text.CENTER,70,"WHO IS YOUR "+ordinal+" LOVE?");
		drawPerson(Gfx.screenwidth/4,Gfx.screenheightmid,people[personOffset],personOffset+0);
		Text.display(Text.CENTER-Gfx.screenwidth/4,Gfx.screenheightmid+25,nameList[personOffset],gray);
		for (i in 0...selectedIndices.length){
			Text.display(
				Text.CENTER-Gfx.screenwidth/4,
				Gfx.screenheightmid+10+25*(2+i),
				Math.round(
						diff(
							people[personOffset],
							people[selectedIndices[i]]
						)*100
					)
					+"% "
					+nameList[selectedIndices[i]]
					);
		}

		drawPerson(Gfx.screenwidth*2/4,Gfx.screenheightmid,people[personOffset+1],personOffset+1);
		Text.display(Text.CENTER,Gfx.screenheightmid+25,nameList[personOffset+1],gray);
		for (i in 0...selectedIndices.length){
			Text.display(
				Text.CENTER,
				Gfx.screenheightmid+10+25*(2+i),
				Math.round(
						diff(
							people[personOffset+1],
							people[selectedIndices[i]]
						)*100
					)
					+"% "
					+nameList[selectedIndices[i]]
					);
		}

		drawPerson(Gfx.screenwidth*3/4,Gfx.screenheightmid,people[personOffset+2],personOffset+2);
		Text.display(Text.CENTER+Gfx.screenwidth*1/4,Gfx.screenheightmid+25,nameList[personOffset+2],gray);
		for (i in 0...selectedIndices.length){
			Text.display(
				Text.CENTER+Gfx.screenwidth/4,
				Gfx.screenheightmid+10+25*(2+i),
				Math.round(
						diff(
							people[personOffset+2],
							people[selectedIndices[i]]
						)*100
					)
					+"% "
					+nameList[selectedIndices[i]]
					);
		}
		Gfx.drawtoscreen();
	}

	function updateselectlove(){
		Gfx.drawimage(0,0,"buffer");
		var d1 = distance(Gfx.screenwidth/4,Gfx.screenheightmid*0.95,Mouse.x,Mouse.y);
		var d2 = distance(Gfx.screenwidth*2/4,Gfx.screenheightmid*0.95,Mouse.x,Mouse.y);
		var d3 = distance(Gfx.screenwidth*3/4,Gfx.screenheightmid*0.95,Mouse.x,Mouse.y);		
		if (d1<selectRadius){
			Gfx.drawcircle(Gfx.screenwidth/4,Gfx.screenheightmid*0.95,selectRadius,Col.GREEN);
			if (Mouse.leftclick()){
				state++;
				selectedlover=personOffset+0;
			}
		} else if (d2<selectRadius){
			Gfx.drawcircle(Gfx.screenwidth*2/4,Gfx.screenheightmid*0.95,selectRadius,Col.GREEN);
			if (Mouse.leftclick()){
				state++;
				selectedlover=personOffset+1;
			}
		} else if (d3<selectRadius){
			Gfx.drawcircle(Gfx.screenwidth*3/4,Gfx.screenheightmid*0.95,selectRadius,Col.GREEN);			
			if (Mouse.leftclick()){
				state++;
				selectedlover=personOffset+2;
			}
		}		
	}

	function updatelovedeclaration(){

		var alpha:Float = (5.0-relationshipCount)/5.0;
		if (alpha<0){
			alpha=0;
		}

		var gry = Std.int(0xff*alpha);
		var gray = Gfx.rgb(gry,gry,gry);

		var lovername = nameList[selectedlover].toUpperCase();
		if (relationshipCount==0){
			Text.display(Text.CENTER,40,"YOU LOVE "+lovername+"!");
			Text.display(Text.CENTER,70,"A HYPER UNIQUE UNPRECEDENTED LOVE!");

		} else {
			Text.display(Text.CENTER,70,"YOU LOVE "+lovername+"!");
		}
		if (selectedlover%3==0){
			drawPerson(Gfx.screenwidth/4,Gfx.screenheightmid,people[personOffset],personOffset+0);
			Text.display(Text.CENTER-Gfx.screenwidth/4,Gfx.screenheightmid+25,nameList[personOffset],gray);
			for (i in 0...selectedIndices.length){
				Text.display(
					Text.CENTER-Gfx.screenwidth/4,
					Gfx.screenheightmid+10+25*(2+i),
					Math.round(
							diff(
								people[personOffset],
								people[selectedIndices[i]]
							)*100
						)
						+"% "
						+nameList[selectedIndices[i]]
						);
			}
		} else if (selectedlover%3==1){
			drawPerson(Gfx.screenwidth*2/4,Gfx.screenheightmid,people[personOffset+1],personOffset+1);
			Text.display(Text.CENTER,Gfx.screenheightmid+25,nameList[personOffset+1],gray);
			for (i in 0...selectedIndices.length){
				Text.display(
					Text.CENTER,
					Gfx.screenheightmid+10+25*(2+i),
					Math.round(
							diff(
								people[personOffset+1],
								people[selectedIndices[i]]
							)*100
						)
						+"% "
						+nameList[selectedIndices[i]]
						);
			}
		} else {
			drawPerson(Gfx.screenwidth*3/4,Gfx.screenheightmid,people[personOffset+2],personOffset+2);
			Text.display(Text.CENTER+Gfx.screenwidth*1/4,Gfx.screenheightmid+25,nameList[personOffset+2],gray);
			for (i in 0...selectedIndices.length){
				Text.display(
					Text.CENTER+Gfx.screenwidth/4,
					Gfx.screenheightmid+10+25*(2+i),
					Math.round(
							diff(
								people[personOffset+2],
								people[selectedIndices[i]]
							)*100
						)
						+"% "
						+nameList[selectedIndices[i]]
						);
			}
		}
		if (Mouse.leftclick()){
			state++;
			if (selectedIndices.length<5){
				selectedIndices.push(selectedlover);
			}
			trace(selectedIndices);
			relationshipCount++;
			personOffset+=3;
			if (personOffset+3>=nameList.length){
				personOffset=0;
			}
		}
	}

	function updatebreakupdeclaration(){
		Text.display(Text.CENTER,Text.CENTER,"YOU BROKE UP");
		if (Mouse.leftclick()){
			state=0;
			updateselectloverender();
		}
	}

	function update(){
		switch (state){
			case 0:
				updateselectlove();
			case 1: 		
				updatelovedeclaration();
			case 2:
				updatebreakupdeclaration();
		}
	}
}