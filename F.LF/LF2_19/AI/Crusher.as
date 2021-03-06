// CRUSHER 1.0
// Designed for Davis
// Made by YinYin

//davisspecials
int ego(){
if(rand(22)+1>10*(difficulty)){
 //define variables
 int sfac = 2*(self.facing?1:0)-1;              //own direction (-1: left, 1: right)
 int tfac = 2*(target.facing?1:0)-1;           //target direction (-1: left, 1: right)
 int bfac = (self.facing?1:0)+(target.facing?1:0)-1;//both facing (-1: left, 0: against, 1: right)
 int stxd = self.x-target.x;           //x distance (left > 0 > right)
 int styd = self.y-target.y;          //y distance (above > 0 > below)
 int stzd = abs(self.z-target.z);    //z distance
 int dist = stxd*sfac;              //directional distance
 int tmp = target.mp;
 int smp = self.mp;

 if(self.bdefend>0&&frame(self.num,110,111)&&range(0,80,dist)&&stzd<=13){DdA();return 1;}
 //no mp combo
 if (dist >= 0 && target.state == 12 && styd > 60 && styd < 90){
  if (self.state <= 1){if (stxd > 0){left();}else {right();}return 1;}//run
  else if (self.state == 2){A();return 1;}                           //attack
 }//grab combo
 if (self.frame == 121 && self.ctimer < 50){DdA();}
  //blasts
 if (target.id!=8&&dist >= 600 && stzd <= 40 && self.state <= 1){DfA();}
 else if (dist > 700 && stzd <= 40 && self.frame >= 240 && self.frame <= 264){A();}
 else if (self.frame >= 240 && self.frame <= 264){return 1;}
 //combo breaker
 if (stzd < 10 && dist < 75 && dist >= -5 && target.y == 0 && (self.frame == 111 || self.state == 8 || self.state == 11 || self.state == 16)){
  if (smp >= 225 && self.frame != 111){DuA();}else if (smp >= 75 && self.frame == 111 && (tmp < 193 || smp >= 293)){DdA();}else if (((target.frame >= 280 && target.frame <= 278 && smp >= 225) || tmp < 70) && (target.frame < 70 && target.frame > 72)){D();}return 1;
 }//flip
 else if (self.state == 12){
  if (target.frame == 301 || (target.frame >= 290 && target.frame <= 293) || target.frame == 75){J();}
 }//dash, roll
 else if (self.frame == 215 && self.bdefend >= 20){
  if (dist > 0 && target.frame < 290 && target.frame > 293){J();}else {D();}
 }
 //facing
 if (bfac != 0 && self.state == 7 && stzd < 10 && target.y == 0){//defense
  if (sfac < 0){left();}else {right();}//turn
 }
 else if (stzd < 10 && dist < 0 && self.state != 1 && self.state != 7){//normal
  if (stxd > 0){left();}else {right();}//turn
 }
 //defending
 if (stzd < 10 && self.state != 7 && target.state == 3 && abs(dist) < 100 && target.y == 0 && ((target.frame >= 280 && target.frame <= 278 && smp >= 225) || tmp < 70) && (target.frame < 70 && target.frame > 72)){D();}//combos
 else if (stzd < 10 && dist < 70 && dist >= -5){
  if (target.hp > 0 && target.hp <= 114 && smp >= 225 && target.state != 12 && target.state != 7){DuA();return 1;}//finisher
  else if (self.frame == 39 && target.state == 12){J();return 1;}                                                 //super combo
  else if ((self.frame == 278 || self.frame == 279) && tmp >= 225 && target.shake > 0){DuA();return 1;}           //safe combo
  else if ((target.state == 16 || target.state == 8) && smp >= 150 && (tmp < 193 || smp >= 293)){DdA();return 1;} //starter
  else if (target.state == 16 && self.state == 0 && tmp >= 225){if (stxd > 0){left();}else {right();}return 1;}    //grab
  else if ((self.frame == 281 || self.frame == 282) && target.state == 12){if (smp >= 450){DuA();return 1;}       //doubleDstart
   else if (smp >= 100){J();return 1;}else if (stxd > 0){left();}else {right();}return 1;}                          //low mp start
  else if (target.hp > 0 && target.state == 12 && styd > 90 && self.frame == 215 && smp >= 225){DuA();return 1;}  //double dragon
  else if ((target.frame == 181 || target.frame == 187) && target.hp > 0 && smp >= 225){DuA();return 1;}          //fall dragon
 }
 //opportunities
 if (self.state == 5 || self.state == 9 || (self.frame == 292 && styd < 7)){//dash,grab,leap attack
  if ((target.hp <= 138 || self.ctimer < 40) && self.state == 9 && smp >= 300){DdA();}      //finisher
  else if ((target.hp <= 114 || self.ctimer < 40) && self.state == 9 && smp >= 225){DuA();}//finisher
  else if (self.ctimer < 40 && self.state == 9 && smp >= 75 && tmp < 225){DdA();return 1;}//end
  else {A();}return 1;}                                                                  //attack
  else if (self.frame == 292 || frame(self.num,85,109) || self.frame == 284){return 1;} //wait
 //void unwanted inputs
 if (self.DrA >= 2 || self.DlA >= 2 || self.DuA >= 2 || self.DdA >= 2 || self.DuJ >= 2){
  if (self.z - target.z < 0){down();}else {up();}
 }
}
 return 0;
}
//davisspecials

void id(){//main function
//add full object loading sequence
//create target selection
//create ego wrapper
//create moving functions/approaching/fleeing/waiting
   inputs();
   array<array<int>>o=get_objects();
   if(stage_clear){right();down();}
   else if(stall(o[0][0]))return;
   else if(rebound(o[0][0]))return;
   else if(dodge(o[0]))return;
   
   if(is_opponent(o[1][0])){
      loadTarget(o[1][0]);
      if(ego()==0&&target.hp>0){
         approach_opponent(o[1][0]);
         if(rand(22)+1>10*(difficulty))act(o[1][0]);
      }
   }
}

//oldstuff
bool facing_against(){
   //true if self and target face opposite directions
   //add variable objects
   return (self.facing!=target.facing)?true:false;
}
void DfA(){
   if(xdistance(self.num,target.num) > 0){DrA();}
   else{DlA();}
}
bool frame(int i, int min, int max){
   //true if between min and max
   if(!is_object(i)){return false;}
   return range(min,max,target.frame);
}
void act(int o){
  if(target.state!=14&&target.blink==0){
   //special moves, attacking, jumping, picking, combos, etc, ...
   if(target.state!=3&&target.state!=2&&target.frame!=213&&range(100,180+abs(self.x_velocity),abs(xdistance(self.num,o)))&&range(0,40+abs(self.z_velocity),abs(zdistance(self.num,o)))){
	 if(self.state<=1){run();}
	 else if(self.state==2){J();A();}
   }
   else if(opponent_close(o)){attack();}
  }
}
bool opponent_close(int i){
   //true if opponent in range
   //pass object number and ranges
   return (loadTarget(i)==0&&range(0,80,abs(xdistance(self.num,target.num)))&&range(0,15,abs(zdistance(self.num,target.num))))?true:false;
}
void attack(){
   //attack towards target
   if(facing_distance(self.num,target.num)>0){turn();}
   if(target.state==16){DdA();}
   else{A(1,0);}
}
int facing_distance(int s, int t){
   //positive: target distance to the front
   return xdistance(s,t)*(2*(self.facing?1:0)-1);
}
void approach_opponent(int o){
   //approach opponent, be aware of item?
   if(is_opponent(o)&&(target.state==14||target.blink!=0)){
	  if(target.id==4||target.id==5){move_towards(o);}
      else{move_away(o);}
   }
   else if(!range(0,5,abs(zdistance(self.num,o)))||!range(0,65,abs(xdistance(self.num,o)))){
      if(self.state<=1&&!range(0,300,abs(xdistance(self.num,o)))&&facing_towards()){run();}
      else if(self.state<=1&&!range(0,80,abs(xdistance(self.num,o)))){move_above(o);}
	  else{move_towards(o);}
   }
}
void run(){
   //run forward
   if(self.facing==false){right(1,0);}else{left(1,0);}
}
bool facing_towards(){
   //true if self faces target
   //add variable objects
   return ((self.facing?-1:1)*xdistance(self.num,target.num)>0)?true:false;
}
void move_above(int i){
   //walk above target i
   //add desired x and z distances
   if(!range(0,10+abs(self.x_velocity),abs(xdistance(self.num,i)))){
      if(xdistance(self.num,i)<0){left(1,1);}else{right(1,1);}
   }
   if(range(0,30+abs(self.z_velocity),abs(zdistance(self.num,i)))){
      if(zdistance(self.num,i)<0){down(1,1);}else{up(1,1);}
   }
}
void move_away(int i){
   //walk away from target i
   //add desired x and z distances
      if(xdistance(self.num,i)<0){right(1,1);}else{left(1,1);}
      if(zdistance(self.num,i)<0){down(1,1);}else{up(1,1);}
}
void move_towards(int i){
   //walk towards target i
   //add desired x and z distances
   if(!range(0,60+18*(difficulty-2)+abs(self.x_velocity),abs(xdistance(self.num,i)))){
      if(xdistance(self.num,i)<0){left(1,1);}else{right(1,1);}
   }
   if(!range(0,10+abs(self.z_velocity),abs(zdistance(self.num,i)))){
      if(zdistance(self.num,i)<0){up(1,1);}else{down(1,1);}
   }
}
bool range(int min, int max, int i){
   //true if i is between min and max
   //make frame use the same form
   return (i>=min&&i<=max)?true:false;
}
int xdistance(int s, int t){
   //x distance between s and t
   loadTarget(s);
   int sx=target.x;
   loadTarget(t);
   int tx=target.x;
   return tx-sx;
}
int zborder1(int z){
   //z distance to the top
   return z-bg_zwidth1;
}
int zborder2(int z){
   //z distance to the bottom
   return bg_zwidth2-z;
}
int zdistance(int s, int t){
   //z distance between s and t
   loadTarget(s);
   int sz=target.z;
   loadTarget(t);
   int tz=target.z;
   return tz-sz;
}
//oldstuff

void defend(int i){//turn against i and defend
   if(!facing_against(i)){turn();}
   D(1,0);
}

void forward(){//press forward direction
   forward(1);
}
void forward(int h){//press forward direction
   if(self.facing){left(1,h);}else{right(1,h);}
}

void towards(int i){//move towards object i
   towards(i,1);
}
void towards(int i, int h){//move towards object i
   if(facing_towards(i)){forward(h);}else{turn();}
   if(self.z<game.objects[i].z)down(1,h);
   else if(self.z>game.objects[i].z)up(1,h);
}

void inputs(){//void inputs
   up(0,0);down(0,0);left(0,0);right(0,0);D(0,0);J(0,0);A(0,0);
}

void turn(){//press opposite direction
   if(self.facing){right(1,0);}else{left(1,0);}
}

bool dodge(int[] i){//dodge attack
   if(!is_reboundable(i[0])&&i[1]>=dodge_time(i)&&i[3]!=-1){
      if(is_chase(i[0])){towards(i[0],0);return true;}
      if((i[3]<self.z||i[3]<=bg_zwidth1+15)&&i[3]<=bg_zwidth2-15)down();
      else up();
	  return true;
   }
   return false;
}

bool facing_against(int i){//check if facing against i
   if(has_direction(i))return (self.facing!=game.objects[i].facing)?true:false;
   return facing_towards(i);
}

bool facing_towards(int i){//true if self faces target
   return ((self.facing?-1:1)*(self.x-game.objects[i].x)<0)?true:false;
}

bool has_direction(int i){//true if the object has an attack relevant direction
   if(game.objects[i].throwinjury!=0||game.objects[i].data.frames[game.objects[i].frame1].state==18)return false;
   return true;
}

bool has_gravity(int i){//true if a character i has gravity
//add other object types - return gravity value instead
   return is_character(i)&&game.objects[i].y<0;
}

bool intersect(int[] a, int[] b){//check if spaces a and b intersect
 if(a[1]<b[0]||
  b[1]<a[0]||
  a[2]>b[3]||
  b[2]>a[3]||
  a[4]>b[5]||
  b[4]>a[5]||
  (a[0]==a[1]&&a[1]==a[2]&&a[2]==a[3]&&a[3]==a[4]&&a[4]==a[5])||
  (b[0]==b[1]&&b[1]==b[2]&&b[2]==b[3]&&b[3]==b[4]&&b[4]==b[5])){return false;}
 return true;
}

bool is_character(int i){//true if i is a character
   return (is_object(i)&&game.objects[i].data.type==0)?true:false;
}

bool is_chase(int i){//true if i is a chase
   if(!is_character(i)&&(game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==1||
      game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==2||
	  game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==3||
	  game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==4||
	  game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==10||
	  game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==12||
	  game.objects[i].data.frames[game.objects[i].frame1].hit_Fa==14))return true;
   return false;
}

bool is_object(int i){//true if i is an object
   return game.exists[i];
}

bool is_opponent(int i){//true if i is a character
   return (is_character(i)&&game.objects[i].hp>0&&game.objects[i].team!=self.team)?true:false;
}

bool is_reboundable(int i){//true if i is reboundable
   return (is_object(i)&&!is_character(i)&&game.objects[i].data.frames[game.objects[i].frame1].state==3000)?true:false;
}

bool is_stoppable(int i){//true if i is reboundable
   return (is_object(i)&&!is_character(i)&&game.objects[i].data.frames[game.objects[i].frame1].state<=3000&&game.objects[i].data.frames[game.objects[i].frame1].state!=1004&&game.objects[i].data.frames[game.objects[i].frame1].state!=2004)?true:false;
}

bool rebound(int i){//stop/rebound projectiles
//pass on attack array
//replace time_till_impact with loaded object parameters
//create attack() function and item picking check
   //difficulty barrier
   if(rand(difficult2(0))>3)return false;
   //reboundable without risk
   if(is_stoppable(i)&&
   time_till_impact(i, self.num)>attack_startup(self.num,self.frame)&&
   time_till_impact(self.num, get_attack_frame(self.num,self.frame), i, -1)<attack_startup(self.num,self.frame)){
      A();return true;
   }
   return false;
}

bool stall(int i){//minimize damage
//pass on attack array
//replace time_till_impact with loaded object parameters
   //difficulty barrier
   if(rand(difficult2(0))>3)return false;
   //always flip to avoid throwinjury
   if(game.objects[self.num].throwinjury!=0&&(self.frame==182||self.frame==188)){J();return true;}
   else if(!is_object(i))return false;
   //determine reaction speed
   if(time_till_impact(i, self.num)<=difficult(1)){
      //defend or roll
      if(self.state<=2||self.frame==215){defend(i);return true;}
	  //flip
      if(self.frame==182||self.frame==188){J();return true;}
   }
   return false;
}

int attack_startup(int o, int f){//time it takes to perform a basic attack
   int t=0;
   if(get_attack_start(o,f)!=-1){
      for(int i = get_attack_start(o,f); i < 400; i=game.objects[o].data.frames[i].next){
	     t+=game.objects[o].data.frames[i].wait;
		 if(game.objects[o].data.frames[i].itr_count>0&&game.objects[o].data.frames[i].itrs[0].kind==0){
		    return t;
	     }
	  }
   }
   return 31;
}

int difficult(int i){//translate difficulty into values: 0,2,4,6 or 1,3,5,7 or ...
   return 2*difficulty+2+i;
}
int difficult2(int i){//translate difficulty into values: 0,4,16,36 or 1,9,25,49 or ...
   return difficult(i)*difficult(i);
}

int dodge_time(int[] i){//returns time it takes to dodge
//somewhat imprecise, more z speeds to add
   float z=game.objects[self.num].data.frames[self.frame].dvz;
   if(self.state<2)z=game.objects[self.num].data.walking_speedz;
   else if(self.state==2)z=game.objects[self.num].data.running_speedz;
   for(int t = 0; t < 31; ++t){
      if(self.z+z*4*t>i[3]+i[2])return t;
      if(self.z-z*4*t<i[3]-i[2])return t;
   }
   return 31;
}

int get_attack_frame(int o, int f){//get attack frame for object o in frame f
   if(get_attack_start(o,f)!=-1){
      for(int i = get_attack_start(o,f); i < 400; i=game.objects[o].data.frames[i].next){
		 if(game.objects[o].data.frames[i].itr_count>0&&game.objects[o].data.frames[i].itrs[0].kind==0){
		    return i;
	     }
	  }
   }
   return 0;
}

int get_attack_start(int o, int f){//get attack start for object o in frame f
//include random frame 65, super punch 70, weapon attacks
   if(game.objects[o].weapon_type==0){
      if(game.objects[o].data.frames[f].state<=1)return 60;
      else if(game.objects[o].data.frames[f].state==2)return 85;
      else if(game.objects[o].data.frames[f].state==4)return 80;
      else if(game.objects[o].data.frames[f].state==5)return 90;
   }
   return -1;
}

int square_distance(int i, int o){//returns squared distance between object i and o
   return(
   ((game.objects[i].x-game.objects[o].x)*(game.objects[i].x-game.objects[o].x))
   +((game.objects[i].y-game.objects[o].y)*(game.objects[i].y-game.objects[o].y))/3
   +3*((game.objects[i].z-game.objects[o].z)*(game.objects[i].z-game.objects[o].z)));
}

int time_till_impact(int o, int x){//returns time till impact of o on x
//remove when replaced with get_attack_info
   return time_till_impact(o, game.objects[o].frame1 ,x ,game.objects[x].frame1);
}
int time_till_impact(int o, int fo, int x, int fx){//returns time till impact of o in frame fo on x in frame fi
//remove when replaced with get_attack_info
   if(fo==-1)fo=game.objects[o].frame1;
   if(fx==-1)fx=game.objects[x].frame1;
   if(is_object(x)&&o!=x&&is_object(o)){
      if(game.objects[x].data.frames[fx].bdy_count>0&&game.objects[x].vrest==0&&game.objects[x].blink<=1&&game.objects[o].data.frames[fo].itr_count>0&&game.objects[o].arest==0){
         for(int i = 0; i < game.objects[o].data.frames[fo].itr_count; ++i){
	        if((game.objects[o].team!=game.objects[x].team||game.objects[o].data.frames[fo].state==18||game.objects[o].data.frames[fo].state==12)&&
			   (self.state!=12||game.objects[o].data.frames[fo].itrs[i].fall>=60)&&
			   game.objects[o].data.frames[fo].itrs[i].kind!=1&&
		       game.objects[o].data.frames[fo].itrs[i].kind!=2&&
			   (game.objects[o].throwinjury!=0||
			   game.objects[o].data.frames[fo].itrs[i].kind!=4)&&
			   (game.objects[game.objects[o].weapon_holder].data.frames[game.objects[game.objects[o].weapon_holder].frame1].wpoint.attacking!=0||
			   game.objects[o].data.frames[fo].itrs[i].kind!=5)&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=6&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=7&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=8&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=14&&
		   	   game.objects[o].data.frames[fo].itrs[i].effect!=4){
               for(int j = 0; j < game.objects[x].data.frames[fx].bdy_count; ++j){
                  for(int t = 0; t < 31; ++t){
	                 if(intersect(bdy(x,j,fx,t),itr(o,i,fo,t)))return t;
   			      }
   			   }
            }
         }
      }
   }
   return 31;
}

int[] bdy(int o, int i, int f, int t){//get bdy i of object o in frame f at time t from now
   array<int>r={0,0,0,0,0,0};
   if(game.objects[o].data.frames[f].bdy_count>i){
      r[game.objects[o].facing?1:0]= game.objects[o].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].bdys[i].x -(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].centerx;
      r[game.objects[o].facing?0:1]= game.objects[o].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].bdys[i].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].bdys[i].w -(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].centerx;
      r[0]+=game.objects[o].x_velocity*t;
      r[1]+=game.objects[o].x_velocity*t;
      r[2]=game.objects[o].y+game.objects[o].data.frames[f].bdys[i].y-game.objects[o].data.frames[f].centery;
      r[3]=game.objects[o].y+game.objects[o].data.frames[f].bdys[i].y+game.objects[o].data.frames[f].bdys[i].h-game.objects[o].data.frames[f].centery;
      r[2]+=game.objects[o].y_velocity*t+(has_gravity(o)?1.7:0)*t;
      r[3]+=game.objects[o].y_velocity*t+(has_gravity(o)?1.7:0)*t;
      r[4]=game.objects[o].z +game.objects[o].z_velocity*t;
      r[5]=game.objects[o].z +game.objects[o].z_velocity*t;
   }
   return r;
}

int[] get_attack_info(int o, int x){
   return get_attack_info(o, game.objects[o].frame1 ,x ,game.objects[x].frame1);
}
int[] get_attack_info(int o, int fo, int x, int fx){
   array<int>a={31,0,-1,14};
   if(fo==-1)fo=game.objects[o].frame1;
   if(fx==-1)fx=game.objects[x].frame1;
   if(is_object(x)&&o!=x&&is_object(o)){
      if(game.objects[x].data.frames[fx].bdy_count>0&&game.objects[x].vrest==0&&game.objects[x].blink<=1&&game.objects[o].data.frames[fo].itr_count>0&&game.objects[o].arest==0){
         for(int i = 0; i < game.objects[o].data.frames[fo].itr_count; ++i){
	        if((game.objects[o].team!=game.objects[x].team||game.objects[o].data.frames[fo].state==18||game.objects[o].data.frames[fo].state==12)&&
			   (self.state!=12||game.objects[o].data.frames[fo].itrs[i].fall>=60)&&
			   game.objects[o].data.frames[fo].itrs[i].kind!=1&&
		       game.objects[o].data.frames[fo].itrs[i].kind!=2&&
			   (game.objects[o].throwinjury!=0||
			   game.objects[o].data.frames[fo].itrs[i].kind!=4)&&
			   (game.objects[game.objects[o].weapon_holder].data.frames[game.objects[game.objects[o].weapon_holder].frame1].wpoint.attacking!=0||
			   game.objects[o].data.frames[fo].itrs[i].kind!=5)&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=6&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=7&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=8&&
		   	   game.objects[o].data.frames[fo].itrs[i].kind!=14&&
		   	   game.objects[o].data.frames[fo].itrs[i].effect!=4){
               for(int j = 0; j < game.objects[x].data.frames[fx].bdy_count; ++j){
                  for(int t = 0; t < 31; ++t){
	                 if(intersect(bdy(x,j,fx,t),itr(o,i,fo,t))){
					    a[0]=t;
						a[1]=game.objects[o].data.frames[fo].itrs[i].injury;
						a[2]=game.objects[o].z+game.objects[o].z_velocity*t;
						if(game.objects[o].data.frames[fo].itrs[i].zwidth!=0)a[3]=game.objects[o].data.frames[fo].itrs[i].zwidth-1;
						return a;
					 }
   			      }
   			   }
            }
         }
      }
   }
   return a;
}

int[][] get_objects(){//find all essential object numbers and parameters
//add more required parameters
   array<array<int>>o={
   {-1,31,-1,-1,14},
   {-1,2147483647},
   {-1,2147483647},
   {-1,2147483647},
   };
   //0,0: object first to hit
   array<int>a={31,-1,-1,14};
   //0,1: time till it hits
   //0,2: injury
   //0,3: z at impact
   //0,4: zwidth-1
   //1,0: closest opponent
   //1,1: closest opponent distance
   //2,0: second closest opponent
   //2,1: second closest opponent distance
   //3,0: weakest opponent
   //3,1: weakest opponent distance
   //4: closest boss
   //5: closest item
   //6: closest milk
   //7: closest beer
   //8: command frame
   for (int i=0;i<400;++i){
      if(is_object(i)){
	     a=get_attack_info(i,self.num);
         if(a[0]<o[0][1]){o[0][0]=i;o[0][1]=a[0];o[0][2]=a[1];o[0][3]=a[2];o[0][4]=a[3];}
         else if(a[0]==o[0][1]&&a[1]<o[0][2]){o[0][0]=i;o[0][1]=a[0];o[0][2]=a[1];o[0][4]=a[3];}
		 if(is_opponent(i)&&square_distance(self.num,i)<o[1][1]){o[1][1]=square_distance(self.num,i);o[2][0]=o[1][0];o[1][0]=i;}
		 else if(is_opponent(i)&&square_distance(self.num,i)<o[2][1]){o[2][1]=square_distance(self.num,i);o[2][0]=i;}
		 if(is_opponent(i)&&game.objects[i].hp<o[3][1]){o[3][1]=game.objects[i].hp;o[3][0]=i;}
		 else if(is_opponent(i)&&game.objects[i].hp==o[3][1]){o[3][0]=-1;}
      }
   }
   return o;
}

int[] itr(int o, int i, int f, int t){//get itr i of object o in frame f at time t from now
   array<int>r={0,0,0,0,0,0};
   if(game.objects[o].data.frames[f].itr_count>i){
      r[game.objects[o].facing?1:0]= game.objects[o].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].itrs[i].x -(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].centerx;
      r[game.objects[o].facing?0:1]= game.objects[o].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].itrs[i].x +(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].itrs[i].w -(game.objects[o].facing?-1:1)*game.objects[o].data.frames[f].centerx;
      r[0]+=game.objects[o].x_velocity*t;
      r[1]+=game.objects[o].x_velocity*t;
      r[2]=game.objects[o].y+game.objects[o].data.frames[f].itrs[i].y-game.objects[o].data.frames[f].centery;
      r[3]=game.objects[o].y+game.objects[o].data.frames[f].itrs[i].y+game.objects[o].data.frames[f].itrs[i].h-game.objects[o].data.frames[f].centery;
      r[2]+=game.objects[o].y_velocity*t+(has_gravity(o)?1.7:0)*t;
      r[3]+=game.objects[o].y_velocity*t+(has_gravity(o)?1.7:0)*t;
      int z=game.objects[o].data.frames[f].itrs[i].zwidth;
      if(z==0)z=14;
      r[4]=game.objects[o].z-z +game.objects[o].z_velocity*t;
      r[5]=game.objects[o].z+z +game.objects[o].z_velocity*t;
   }
   return r;
}