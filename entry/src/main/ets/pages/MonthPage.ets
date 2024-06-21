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
          /**  if (i.WholeDay == 1) {
              this.scheduleModelArray.push(i)
            }else if(i.WholeDay == 0)
              if(i.StartDate != i.EndDate){

              }**/
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth == this.currentMonth && i.EndMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
        if (i.StartMonth < this.currentMonth && i.EndMonth > this.currentMonth) {
          this.scheduleModelArray.push(i)
        }
        if (i.EndMonth == this.currentMonth && i.StartMonth != this.currentMonth) {
          if (i.StartDate <= this.currentDate && i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
      }
    }
    if(this.scheduleModelArray.length!=0){
      this.hasCalendar = true
    }
  }

  /**getScheduleListString(item:ScheduleModel):string{

    let scheduleString:string[] = []
    //日程为当天且未选全天
    if (item.StartDate == item.EndDate&&item.WholeDay==0){
      let stringStart:string = item.HourStart.toString()+':'+(item.MinuteStart < 10 ? '0' + item.MinuteStart.toString() : item.MinuteStart.toString())

      let stringEnd:string = item.HourEnd.toString()+':'+(item.MinuteEnd < 10 ? '0' + item.MinuteEnd.toString() : item.MinuteEnd.toString())

      let string:string = stringStart+stringEnd
      return string
    }
    //日程为当天且选全天
    else if (item.StartDate == item.EndDate&&item.WholeDay == 1){

      return '全天'
    }
    //日程超过一天且今天为开始日
    else if (item.StartDate == this.currentDate&&item.StartDate!=item.EndDate){
      let stringStart:string = item.HourStart.toString()+':'+(item.MinuteStart < 10 ? '0' + item.MinuteStart.toString() : item.MinuteStart.toString())
      return stringStart+'开始'
    }
    //日程超过一天且今天为结束日
    else if (item.EndDate == this.currentDate&&item.StartDate!=item.EndDate){
      let stringEnd:string = item.HourEnd.toString()+':'+(item.MinuteEnd < 10 ? '0' + item.MinuteEnd.toString() : item.MinuteEnd.toString())
      return stringEnd+'结束'
    }
    //在日程范围内且不为开始天和结束天
    else if (item.EndDate>this.currentDate&&item.StartDate<this.currentDate&&item.StartDate!=item.EndDate){

      return '全天'
    }
  }
**/
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
        Text('农历')
          .width(230)
          .height(50)
          .fontSize(15)
          .onClick(()=>{
            router.back({url:'pages/Index',params:{currentYear:this.currentYear}})
          })
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
            Row() {
              Column({space:10}){
                Text(item.WholeDay == 1? '全':item.EndDate == item.StartDate?item.HourStart.toString() + ':' +(item.MinuteStart <10? '0'+item.MinuteStart.toString():
                item.MinuteStart.toString()):item.StartDate == this.currentDate?item.HourStart.toString() + ':' +(item.MinuteStart <10? '0'+item.MinuteStart.toString():item.MinuteStart.toString()):
                item.EndDate == this.currentDate?item.HourEnd.toString() + ':' +(item.MinuteEnd <10? '0'+item.MinuteEnd.toString():item.MinuteEnd.toString()):'全')
                  .fontSize(10)

                Text((item.WholeDay == 1? '天':item.EndDate == item.StartDate?item.HourEnd.toString() + ':' +(item.MinuteEnd <10? '0'+item.MinuteEnd.toString():
                item.MinuteEnd.toString()):item.StartDate == this.currentDate?'开始':
                item.EndDate == this.currentDate?'结束':'天'))
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

              Text(item.Title)
              .fontSize(25)
              .margin({left:10})

            }.width('100%')
            .height(50)
            .borderRadius(15)
            .justifyContent(FlexAlign.Start)
            .builder()
          }
        })
      }.width('95%')
      .height('35%')
    }
    .width('100%')
    .height('100%')
  }
}