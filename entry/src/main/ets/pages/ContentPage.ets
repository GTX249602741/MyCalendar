import router from '@ohos.router'
import { Const, ScheduleModel } from '../model/ScheduleModel'

import DbUtil from '../Util/DbUtil'
import { DatePickerDialogPage } from './DatePickerDialogPage'
import { DatePickerDialogPage2 } from './DatePickerDialogPage2'
@Entry
@Component
struct ContentPage {

  param:any = router.getParams()

  @State item:ScheduleModel = this.param.item

  @State title: string = this.item.Title

  @State content: string = this.item.content

  date:Date = new Date()

  @State selectedStartYear:number = this.item.StartYear

  @State selectedStartMonth:number = this.item.StartMonth

  @State selectedStartDate:number = this.item.StartDate

  @State selectedStartHour:number = this.item.HourStart

  @State selectedStartMinute:number = this.item.MinuteStart

  @State selectedEndYear:number = this.item.EndYear

  @State selectedEndMonth:number = this.item.EndMonth

  @State selectedEndDate:number = this.item.EndDate

  @State selectedEndHour:number = this.item.HourEnd

  @State selectedEndMinute:number = this.item.MinuteEnd

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

  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_cancel'))
          .size({width:30,height:30})
          .onClick(()=>{
            router.back()
          })


        Blank()
        Image($r('app.media.ic_public_ok'))
          .size({width:30,height:30})
          .onClick(async ()=>{
            this.item.StartYear = this.selectedStartYear
            this.item.StartMonth = this.selectedStartMonth
            this.item.StartDate = this.selectedStartDate
            this.item.EndYear = this.selectedEndYear
            this.item.EndMonth = this.selectedEndMonth
            this.item.EndDate = this.selectedEndDate
            this.item.IsFinish = 0
            if (this.fullDayFlag == false) {
              this.item.WholeDay = 0
              this.item.HourStart = this.selectedStartHour
              this.item.MinuteStart = this.selectedStartMinute
              this.item.HourEnd = this.selectedEndHour
              this.item.MinuteEnd = this.selectedEndMinute
            }else {
              this.item.WholeDay = 1
              this.item.HourStart = null
              this.item.MinuteStart = null
              this.item.HourEnd = null
              this.item.MinuteEnd = null
            }
            this.item.content = this.content
            let num = await DbUtil.update('DATE',this.item,Const,this.item.Title)
            console.log('test6',num.toString())
            router.back()
          })
      }
      .margin({top:10})
      .width('95%')


      Row(){
        Text(this.title)
          .fontSize(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({top:70})
      .borderRadius(15)


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
            this.fullDayFlag = isOn
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
    }.width('100%')
    .height('100%')
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

}