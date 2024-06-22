import { CJCalendar, OptMode } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { getLunarDesc } from '../cjcalendar/src/main/ets/components/components/CJCalendar'
import { Lunar, Solar} from 'lunar';
import router from '@ohos.router'
import ArrayList from '@ohos.util.ArrayList';
import { ScheduleModel } from '../model/ScheduleModel'
import dbUtil from '../Util/DbUtil'
import thermal from '@ohos.thermal';
import relationalStore from '@ohos.data.relationalStore';
import { Const } from '../model/ScheduleModel'

@Entry
@Component
export struct MonthPage {

  date:Date = new Date()
  //linkMonth:any = AppStorage.Link('currentMonth')
  @State param:any = router.getParams()
  //linkYear:any = AppStorage.Link('currentYear')
  @State @Watch("onYearChange")currentYear:number = AppStorage.Get('currentYear')

  @State @Watch('onMonthChange')currentMonth:number = AppStorage.Get('currentMonth')

  @State currentDate:number = this.date.getDate()

  @State item:CJDateItem[] = []

  @State hasCalendar:boolean = false

  @State scheduleModelArray:Array<ScheduleModel> = []

  scroller:Scroller = new Scroller()

  @State show:boolean = false

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }
  onYearChange(){
    AppStorage.Set('currentYear',this.currentYear)
    console.log('test3',AppStorage.Get('currentYear').toString())
  }

  onMonthChange(){
    AppStorage.Set('currentMonth',this.currentMonth)
    console.log('test3',AppStorage.Get('currentYear').toString())
  }
  async getScheduleList(){
    this.scheduleModelArray = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.isNotNull("Title");
    let array = await dbUtil.queryForList(predicates, Const)
    for (let i of array) {
      if (i.StartYear <= this.currentYear && i.EndYear >= this.currentYear) {
        if (i.StartMonth == this.currentMonth && i.EndMonth == this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {

            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth == this.currentMonth && i.EndMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate ) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth < this.currentMonth && i.EndMonth > this.currentMonth) {
          this.scheduleModelArray.push(i)
        }
        if (i.EndMonth == this.currentMonth && i.StartMonth != this.currentMonth) {
          if (i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
      }
    }
    if(this.scheduleModelArray.length!=0){
      this.hasCalendar = true
    }
  }

  aboutToAppear(): void {

    let today: CJDateItem = new CJDateItem(this.date,null,null,Solar.fromDate(this.date))
    //this.currentYear = this.date.getFullYear()
    //this.currentMonth = this.date.getMonth()+1
   // this.currentDate = this.date.getDate()
    if (this.currentMonth != this.date.getMonth()+1){
      this.currentDate = 1
      let date1 = new Date(this.currentYear,this.currentMonth,this.currentDate)
      let day: CJDateItem = new CJDateItem(date1,null,null,Solar.fromDate(date1))
      this.item[0] = day
    }
    if(this.currentMonth == this.date.getMonth()+1&&this.currentDate != this.date.getDate()){
      this.currentDate = 1
      let date1 = new Date(this.currentYear,this.currentMonth,this.currentDate)
      let day: CJDateItem = new CJDateItem(date1,null,null,Solar.fromDate(date1))
      this.item[0] = day
    }
    this.item[0] = today

    this.getScheduleList()
  }

  onPageShow(){
    this.getScheduleList()
  }

  onBackPress(){
    router.pushUrl({url:'pages/Index'},router.RouterMode.Single)
   // AppStorage.SetOrCreate('currentYear',this.currentYear)
    //AppStorage.SetOrCreate('currentMonth',this.currentMonth)

  }

  build() {
    Column(){
      CJCalendar({currentYear:$currentYear,currentMonth:$currentMonth,showLunar:true,onSelectedChanged:async (item:CJDateItem[])=>{
        this.item = item
        this.currentYear = item[0].fullYear
        this.currentMonth = item[0].month+1
        this.currentDate = item[0].date

        this.getScheduleList()
        //console.log('test4',this.currentYear.toString())
      },optMode:OptMode.SINGLE})
      //.sharedTransition(this.currentMonth.toString(),{ duration: 200, curve: Curve.Friction})



      Row(){
        Text(this.currentMonth == this.date.getMonth()+1&&this.currentDate == this.date.getDate()? '今天':this.currentMonth+'月'+this.currentDate+'日')
          .width(60)
          .height(50)
          .margin({left:10})
          .fontSize(15)
        Text('农历'+(Lunar.fromDate(new Date(this.currentYear,this.currentMonth-1,this.currentDate))).toString())
          .width(230)
          .height(50)
          .fontSize(15)
      }
      .width('100%')
      .height('7%')
      .justifyContent(FlexAlign.Start)

      Image($r('app.media.ic_public_calendar1'))
        .size({height:100})
        .visibility(this.hasCalendar == false? Visibility.Visible : Visibility.None)
        .margin({top:60})

      Text('没有日程')
        .visibility(this.hasCalendar == false? Visibility.Visible : Visibility.None)
        .fontColor(Color.Gray)

      List({space:15,scroller:this.scroller}){
        ForEach(this.scheduleModelArray,(item:ScheduleModel)=>{
          ListItem(){
            ScheduleItem({item:item,currentDate:$currentDate})
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
          })
        })
      }.width('95%')
      .height('35%')
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ScheduleItem{

  @State show:boolean = false

  item:ScheduleModel

  @Link currentDate:number

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }

  build(){
    Row() {
      Column({space:10}){
        Text(this.item.WholeDay == 1? '全':this.item.EndDate == this.item.StartDate?this.item.HourStart.toString() + ':' +(this.item.MinuteStart <10? '0'+this.item.MinuteStart.toString():
        this.item.MinuteStart.toString()):this.item.StartDate == this.currentDate?this.item.HourStart.toString() + ':' +(this.item.MinuteStart <10? '0'+this.item.MinuteStart.toString():this.item.MinuteStart.toString()):
        this.item.EndDate == this.currentDate?this.item.HourEnd.toString() + ':' +(this.item.MinuteEnd <10? '0'+this.item.MinuteEnd.toString():this.item.MinuteEnd.toString()):'全')
          .fontSize(10)

        Text((this.item.WholeDay == 1? '天':this.item.EndDate == this.item.StartDate?this.item.HourEnd.toString() + ':' +(this.item.MinuteEnd <10? '0'+this.item.MinuteEnd.toString():
        this.item.MinuteEnd.toString()):this.item.StartDate == this.currentDate?'开始':
        this.item.EndDate == this.currentDate?'结束':'天'))
          .fontSize(10)

      }
      .width('10%')
      .margin({left:10,top:10,bottom:10,right:10})

      Divider()
        .vertical(true)
        .height(30)
        .color('#0091FF')
        .strokeWidth(3)
        .lineCap(LineCapStyle.Round)

      Text(this.item.Title)
        .fontSize(25)
        .margin({left:10})

    }.width('100%')
    .height(50)
    .borderRadius(15)
    .justifyContent(FlexAlign.Start)
    .builder()
  }

}