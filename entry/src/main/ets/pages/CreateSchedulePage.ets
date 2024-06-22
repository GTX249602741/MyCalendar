import font from '@ohos.font'
import { DatePickerDialogPage } from './DatePickerDialogPage'
import { DatePickerDialogPage2 } from './DatePickerDialogPage2'
import { Const } from '../model/ScheduleModel'
import DbUtil from '../Util/DbUtil'
import { ScheduleModel } from '../model/ScheduleModel'
import router from '@ohos.router'
@Entry
@Component
struct CreateSchedulePage {
  @State title: string = ''

  @State content: string = ''

  date:Date = new Date()

  @State selectedStartYear:number = this.date.getFullYear()

  @State selectedStartMonth:number = this.date.getMonth()+1

  @State selectedStartDate:number = this.date.getDate()

  @State selectedStartHour:number = this.date.getHours()

  @State selectedStartMinute:number = this.date.getMinutes()

  @State selectedEndYear:number = this.date.getFullYear()

  @State selectedEndMonth:number = this.date.getMonth()+1

  @State selectedEndDate:number = this.date.getDate()

  @State selectedEndHour:number = this.date.getHours()

  @State selectedEndMinute:number = this.date.getMinutes()

  @State fullDayFlag:boolean = false

  day:number = this.date.getDay()

  @State day2:string = this.getDay(this.day)

  @State day1:string = this.getDay(this.day)

  getDay(date:number):string{
    switch (date){
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 0:
        return '日';

    }
  }

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }

  controller:CustomDialogController = new CustomDialogController({
    builder:DatePickerDialogPage({selectedYear:$selectedStartYear,selectedMonth:$selectedStartMonth,selectedDate:$selectedStartDate,selectedHour:$selectedStartHour,selectedMinute:$selectedStartMinute,fullDayFlag:$fullDayFlag,day1:$day1}),
    alignment:DialogAlignment.Bottom,
    offset:{dx:0,dy:-10}

  })

  controller2:CustomDialogController = new CustomDialogController({
    builder:DatePickerDialogPage2({selectedYear:$selectedEndYear,selectedMonth:$selectedEndMonth,selectedDate:$selectedEndDate,selectedHour:$selectedEndHour,selectedMinute:$selectedEndMinute,fullDayFlag:$fullDayFlag,day1:$day2}),
    alignment:DialogAlignment.Bottom,
    offset:{dx:0,dy:-10}
  })

  onBackPress(){
    router.pushUrl({url:'pages/Index'},router.RouterMode.Single)
  }
  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_cancel'))
          .size({width:30,height:30})
          .onClick(()=>{
            router.back()
          })

        Text('新建日程')
          .fontSize(30)
          .margin({left:15})
        Blank()
        Image($r('app.media.ic_public_ok'))
          .size({width:30,height:30})
          .onClick(()=>{
            let scheduleModel = new ScheduleModel()
            scheduleModel.StartYear = this.selectedStartYear
            scheduleModel.StartMonth = this.selectedStartMonth
            scheduleModel.StartDate = this.selectedStartDate
            scheduleModel.EndYear = this.selectedEndYear
            scheduleModel.EndMonth = this.selectedEndMonth
            scheduleModel.EndDate = this.selectedEndDate
            scheduleModel.IsFinish = 0
            if (this.fullDayFlag == false) {
              scheduleModel.WholeDay = 0
              scheduleModel.HourStart = this.selectedStartHour
              scheduleModel.MinuteStart = this.selectedStartMinute
              scheduleModel.HourEnd = this.selectedEndHour
              scheduleModel.MinuteEnd = this.selectedEndMinute
            }else {
              scheduleModel.WholeDay = 1
              scheduleModel.HourStart = null
              scheduleModel.MinuteStart = null
              scheduleModel.HourEnd = null
              scheduleModel.MinuteEnd = null
            }
            scheduleModel.Title = this.title
            scheduleModel.content = this.content
            DbUtil.insert('DATE',scheduleModel,Const)
            router.back()
          })
      }
      .margin({top:10})
      .width('95%')

      Row(){

        TextInput({text:this.title,placeholder:'标题'})
          .placeholderColor(Color.Black)
          .type(InputType.Normal)
          .height(50)
          .onChange((value=>{
            this.title = value
          }))
          .builder()
          .width('100%')
      }.width('95%')
      .margin({top:70})
      .backgroundColor('#E3E3E3')
      .borderRadius(15)
      .builder()

      Row(){
        TextArea({text:this.content,placeholder:'请输入内容'})
          .size({width:270,height:50})
          .onChange((value=>{
            this.content = value
          }))
          .builder()
          .width('100%')
          .height('100%')
      }.width('95%')
      .height('30%')
      .margin({top:20})
      .backgroundColor('#E3E3E3')
      .borderRadius(15)
      .builder()

      Row(){
        Image($r('app.media.ic_public_clock'))
          .size({width:20,height:20})
          .margin({left:10})
        Text('全天')
          .fontSize(20)
          .margin({left:10})
        Blank()
        Toggle({type:ToggleType.Switch})
          .selectedColor(Color.Blue)
          .size({width:'40',height:'40'})
          .margin({right:10})
          .onChange((isOn:boolean)=>{
            this.fullDayFlag = !this.fullDayFlag
          })

      }
      .width('95%')
      .margin({top:20})
      .borderRadius({topLeft:15,topRight:15})
      .height(50)
      .builder()

      Divider()
      .color(Color.Black)
      .width('95%')

      Row(){
        Column(){

          Text(this.selectedStartHour.toString()+':'+(this.selectedStartMinute <10? '0'+this.selectedStartMinute.toString():this.selectedStartMinute.toString()))
            .fontSize(25)
            .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)

          Text(this.selectedStartMonth.toString()+'月'+this.selectedStartDate.toString()+'日')
            .fontSize(17)
        }
        .onClick(()=>{
          this.controller.open()
        })

        Image($r('app.media.ic_public_arrow_right'))
          .size({width:30,height:30})

        Column(){

          Text(this.selectedEndHour.toString()+':'+(this.selectedEndMinute <10? '0'+this.selectedEndMinute.toString():this.selectedEndMinute.toString()))
            .fontSize(25)
            .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)

          Text(this.selectedEndMonth.toString()+'月'+this.selectedEndDate.toString()+'日')
            .fontSize(17)
        }
        .onClick(()=>{
          this.controller2.open()
        })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('95%')
      .borderRadius({bottomLeft:15,bottomRight:15})
      .height(80)
      .builder()
    }
    .width('100%')
    .height('100%')
  }
}