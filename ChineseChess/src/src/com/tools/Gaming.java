package src.com.tools;

import java.util.ArrayList;

public class Gaming {

	public Gaming() {
		// TODO Auto-generated constructor stub
		initQiZi();
	}
	public ArrayList<Qizi> list;
	//������ʼ��list
	public ArrayList<Qizi>initQiZi(){
		ArrayList<Qizi>list=new ArrayList<Qizi>();
		int k=0;
		//����ĵ�һ��
		for(int i=0;i<34;i++){
			Qizi qizi=new Qizi();
			if(i<9){
				qizi.setId(i+1);
				qizi.setX(i);
				qizi.setY(0);
			}else if(i==9){//��
				qizi.setId(i+1);
				qizi.setX(1);
				qizi.setY(2);
			}else if(i==10){//��
				qizi.setId(i+1);
				qizi.setX(7);
				qizi.setY(2);
			}else if(i>=11&&i<=15){//��
				qizi.setId(i+1);
				qizi.setX(k);
				qizi.setY(3);
				k=k+2;
				if(i==15){
					k=0;
				}
			}else if(i>=16&&i<=20){//��
				qizi.setId(i+1);
				qizi.setX(k);
				qizi.setY(6);
				k=k+2;
			}else if(i==21){//��
				qizi.setId(i+1);
				qizi.setX(1);
				qizi.setY(7);
			}else if(i==22){//��
				qizi.setId(i+1);
				qizi.setX(7);
				qizi.setY(7);
			}else{//��������һ��
				qizi.setId(i+1);
				qizi.setX(i-23);
				qizi.setY(9);
			}
		}
	
		return list;
	}
	//��ö�Ӧ�����ӵĶ���
	public Qizi getlist(int id){
		if(list!=null){
			Qizi qizi=list.get(id-1);
			return qizi;
		}
		return null;
	}
	//��list���и���
	public void changelist(Qizi newp){
		int id=newp.getId();
		list.get(id).setX(newp.getX());
		list.get(id).setY(newp.getY());
	}
}
