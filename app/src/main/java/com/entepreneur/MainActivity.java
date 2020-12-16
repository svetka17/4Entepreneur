package com.entepreneur;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.NumberPicker;
import android.widget.SeekBar;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    Button btnExit, btnProd, btnOstat, btnPrixod, btnRasxod, btnKassa, btnSetting, btnAbout;
    //static DB db;
    static int w=0;
    static int h=0;
    static float scale=0;
    static long invent=0;
    static int no_inv=0;
    static int inv_dat_n=0;
    static int sizeBigButton=15;
    static int sizeMediumButton=15;
    static int sizeSmallButton=15;
    static int sizeBigText=15;
    static int sizeMediumText=15;
    static int sizeSmallText=15;
    static String pathD = "";
    static int butTara=21;
    static int butPgr=15;
    static int butName=15;
    static int butNameS=12;
    static int tabH=15;
    static int tabI=13;
    static int tabBut=15;
    static int butMenu=20;
    static int butKalk=30;
    static int tvH=15;
    static int tvI=17;
    static int seek=50;
    static int red1=50;
    static int green1=50;
    static int blue1=50;
    static int red2=50;
    static int green2=50;
    static int blue2=50;
    static String usr = "";
    static int access=0;
    static int postlitr=0;
    static int num_id=1;
    static int day=1;
    int but_menu=0;
    static String my_pass="svetka";

    static ArrayList<View> getViewsByTag(ViewGroup root){
        ArrayList<View> views = new ArrayList<View>();
        final int childCount = root.getChildCount();
        for (int i = 0; i < childCount; i++) {
            final View child = root.getChildAt(i);
            if (child instanceof ViewGroup) {
                views.addAll(getViewsByTag((ViewGroup) child));
            }
            else
                views.add(child);
        }
        return views;
    }

    static void setSizeFontMain(ViewGroup mlayout) {
        ArrayList<View> alv = getViewsByTag(mlayout);
        for (int i=0; i<alv.size(); i++)
        {
            if (!(alv.get(i) instanceof SeekBar || alv.get(i) instanceof NumberPicker))

                if (alv.get(i) instanceof CheckBox)
                    ((CheckBox)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , tvI);
                else if (alv.get(i) instanceof Button)
                    ((Button)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , butMenu);
                else if (alv.get(i) instanceof EditText)
                    ((EditText)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , tvI);
                else if (((TextView)alv.get(i)).getParent() instanceof TableRow)
                    ((TextView)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , tabH);
                else
                { //int l=1;
                    String[] n = ((TextView)alv.get(i)).getText().toString().split(" ");
                    int nn=
                            ((TextView)alv.get(i)).getText().length();
                    //for (int ii=0; ii<n.length; ii++ )
                    //if (n[ii].length()>l) l=n[ii].length();

                    //Log.d("MyLog", "text = "+((TextView)alv.get(i)).getText().toString()+" l="+n.length);
                    if (n.length==1 || nn<10)
                        ((TextView)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , tvH);
                    else
                        ((TextView)alv.get(i)).setTextSize(TypedValue.COMPLEX_UNIT_PX , tvH/2);
                }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnExit = (Button) findViewById(R.id.btnExit);
        btnExit.setOnClickListener(this);

        btnProd = (Button) findViewById(R.id.btnProd);
        btnProd.setOnClickListener(this);

        btnPrixod = (Button) findViewById(R.id.btnPrixod);
        btnPrixod.setOnClickListener(this);

        btnRasxod = (Button) findViewById(R.id.btnRasxod);
        btnRasxod.setOnClickListener(this);

        btnOstat = (Button) findViewById(R.id.btnOstat);
        btnOstat.setOnClickListener(this);

        btnKassa = (Button) findViewById(R.id.btnKassa);
        btnKassa.setOnClickListener(this);

        btnSetting = (Button) findViewById(R.id.btnSettingSpr);
        btnSetting.setOnClickListener(this);

        btnAbout = (Button) findViewById(R.id.btnAbout);
        btnAbout.setOnClickListener(this);

        //db = new DB(this);
        //db.open();

        Display display = getWindowManager().getDefaultDisplay();
        //DisplayMetrics metricsB = new DisplayMetrics();
        //display.getMetrics(metricsB);
        //display_h=metricsB.heightPixels; display_w=metricsB.widthPixels;
        scale = getResources().getDisplayMetrics().density;
        w = display.getWidth();
        h = display.getHeight();
        //loadSetting();
        MainActivity.setSizeFontMain((LinearLayout)findViewById(R.id.main_ll));
        //makeDialog(-1);
        /*
        int density= getResources().getDisplayMetrics().densityDpi;

        switch(density)
        {
        case DisplayMetrics.DENSITY_LOW:
           Toast.makeText(this, "LDPI", Toast.LENGTH_SHORT).show();
            break;
        case DisplayMetrics.DENSITY_MEDIUM:
             Toast.makeText(this, "MDPI", Toast.LENGTH_SHORT).show();
            break;
        case DisplayMetrics.DENSITY_HIGH:
            Toast.makeText(this, "HDPI", Toast.LENGTH_SHORT).show();
            break;
        case DisplayMetrics.DENSITY_XHIGH:
             Toast.makeText(this, "XHDPI", Toast.LENGTH_SHORT).show();
            break;
        }

        int screenSize = getResources().getConfiguration().screenLayout &
                Configuration.SCREENLAYOUT_SIZE_MASK;

        switch(screenSize) {
            case Configuration.SCREENLAYOUT_SIZE_LARGE:
                Toast.makeText(this, "Large screen",Toast.LENGTH_LONG).show();
                break;
            case Configuration.SCREENLAYOUT_SIZE_NORMAL:
                Toast.makeText(this, "Normal screen",Toast.LENGTH_LONG).show();
                break;
            case Configuration.SCREENLAYOUT_SIZE_SMALL:
                Toast.makeText(this, "Small screen",Toast.LENGTH_LONG).show();
                break;
            default:
                Toast.makeText(this, "Screen size is neither large, normal or small" , Toast.LENGTH_LONG).show();
        }*/
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        if (v.getId() == R.id.btnRasxod)
        //{intent = new Intent(this, RasxodActivity.class); startActivity(intent);}
        if (v.getId() == R.id.btnKassa)
        //{intent = new Intent(this, OtchetActivity.class); startActivity(intent);}
        if (v.getId() == R.id.btnOstat)
        //{intent = new Intent(this, InvHeadActivity.class); startActivity(intent);}
        if (v.getId() == R.id.btnPrixod) {}
        //{intent = new Intent(this, PrixodActivity.class); startActivity(intent);}
        else
            if (access==1)
                switch (v.getId()) {
                    case R.id.btnProd:
                        //intent = new Intent(this, UserActivity.class); startActivity(intent);
                        break;
                    case R.id.btnAbout:
                        //intent = new Intent(this, SettingAllActivity.class); startActivity(intent);
                        break;
                    case R.id.btnSettingSpr:
			   /*Cursor cc = MainActivity.db.getRawData ("select count(*) c from tmc T where T.pgr=1",null);
			   if (cc.moveToFirst()) {
			        do { Log.d("MyLog",cc.getInt(cc.getColumnIndex("c"))+ " count: tmc "+db.getAllData("tmc").getCount());
			        } while (cc.moveToNext());
			      };*/
                        //intent = new Intent(this, SprActivity.class); startActivity(intent);
                        break;
		   /*case R.id.btnKassa:
			   intent = new Intent(this, OtchetActivity.class);
			   startActivity(intent);
			   break;*/
                    //db.delRec("tmc", 6);
                    //   break;
		  /* case R.id.btnExit:
		     finish();
		     break;*/
                }
        if (v.getId() == R.id.btnExit) finish();

    }
}