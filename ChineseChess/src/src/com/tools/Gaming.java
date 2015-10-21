package src.com.tools;

import java.util.ArrayList;

public class Gaming {

	public Gaming() {
		// TODO Auto-generated constructor stub
		initQiZi();
	}
	public ArrayList<Qizi> list;
	//建立初始化list
	public ArrayList<Qizi>initQiZi(){
		ArrayList<Qizi>list=new ArrayList<Qizi>();
		int k=0;
		//上面的第一排
		for(int i=0;i<34;i++){
			Qizi qizi=new Qizi();
			if(i<9){
				qizi.setId(i+1);
				qizi.setX(i);
				qizi.setY(0);
			}else if(i==9){//炮
				qizi.setId(i+1);
				qizi.setX(1);
				qizi.setY(2);
			}else if(i==10){//炮
				qizi.setId(i+1);
				qizi.setX(7);
				qizi.setY(2);
			}else if(i>=11&&i<=15){//卒
				qizi.setId(i+1);
				qizi.setX(k);
				qizi.setY(3);
				k=k+2;
				if(i==15){
					k=0;
				}
			}else if(i>=16&&i<=20){//兵
				qizi.setId(i+1);
				qizi.setX(k);
				qizi.setY(6);
				k=k+2;
			}else if(i==21){//炮
				qizi.setId(i+1);
				qizi.setX(1);
				qizi.setY(7);
			}else if(i==22){//炮
				qizi.setId(i+1);
				qizi.setX(7);
				qizi.setY(7);
			}else{//最下面那一排
				qizi.setId(i+1);
				qizi.setX(i-23);
				qizi.setY(9);
			}
		}
	
		return list;
	}
	//获得对应的棋子的对象
	public Qizi getlist(int id){
		if(list!=null){
			Qizi qizi=list.get(id-1);
			return qizi;
		}
		return null;
	}
	//对list进行更新
	public void changelist(Qizi newp){
		int id=newp.getId();
		list.get(id).setX(newp.getX());
		list.get(id).setY(newp.getY());
	}
}
