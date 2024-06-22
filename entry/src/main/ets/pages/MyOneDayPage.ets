import { MonthDialogPage } from './MonthDialogPage'
import router from '@ohos.router'
import { ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import { Const } from '../model/ScheduleModel'

@Component
export  struct MyOneDayPage {

  date:Date = new Date()

  @State currentYear:number = this.date.getFullYear()

  @State currentMonth:number = this.date.getMonth()+1

  @State currentDate:number = this.date.getDate()

  @Link scheduleModelArray:Array<ScheduleModel>

  @Link hasCalendar:boolean

  scroller:Scroller = new Scroller()

  controller:CustomDialogController = new CustomDialogController({
    builder:MonthDialogPage({currentYear:$currentYear,currentMonth:$currentMonth,currentDate:$currentDate,scheduleModelArray:$scheduleModelArray,hasCalendar:this.hasCalendar}),
    alignment:DialogAlignment.Bottom
  })


  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }

  build() {
      Column() {
        Row() {
          Text('我的一天')
            .fontSize(20)
          Blank()
          Image($r('app.media.ic_public_calendar'))
            .size({ width: 20, height: 20 })
            .onClick(() => {
              this.controller.open()
            })
            .margin({right:10})
          Image($r('app.media.ic_public_add_norm'))
            .size({ width: 20, height: 20 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/CreateSchedulePage'},router.RouterMode.Single)
            })
        }.width('90%')
        .height('7%')

        Row() {
          Text(this.currentYear.toString() + '年' + this.currentMonth.toString() + '月' + this.currentDate.toString() + '日')
            .fontSize(20)
            .width('90%')
            .height('10%')
        }

        Image($r("app.media.RC"))
          .size({ height: 200, width: 200 })
          .margin({ top: 150 })
          .visibility(this.hasCalendar == false ? Visibility.Visible : Visibility.None)
        Text('今天要做什么？')
          .fontSize(20)
          .margin({ top: 20 })
          .visibility(this.hasCalendar == false ? Visibility.Visible : Visibility.None)
        Text('点击+按钮记录一下')
          .fontSize(15)
          .visibility(this.hasCalendar == false ? Visibility.Visible : Visibility.None)

        List({space:15,scroller:this.scroller}) {
          ForEach(this.scheduleModelArray, (item: ScheduleModel) => {
            ListItem() {
              Row() {
                Text(item.WholeDay == 1?'全天':item.HourStart.toString() + ':' + (item.MinuteStart < 10 ? '0' + item.MinuteStart.toString() : item.MinuteStart.toString()))
                  .fontSize(15)
                  .margin({ left: 10, right: 10 })

                Divider()
                  .vertical(true)
                  .color('#0091FF')
                  .height('70%')
                  .strokeWidth(4)
                  .lineCap(LineCapStyle.Round)

                Blank()

                Row() {
                  Text(item.Title)
                    .fontSize(25)
                    .margin({ left: 10 })
                  Text(item.WholeDay == 1?'全天':item.StartDate == item.EndDate?
                  item.HourStart.toString() + ':' +(item.MinuteStart <10? '0'+item.MinuteStart.toString(): item.MinuteStart.toString())+'-'+
                  item.HourEnd.toString() + ':' +(item.MinuteEnd <10? '0'+item.MinuteEnd.toString(): item.MinuteEnd.toString()):
                  item.StartDate == this.currentDate?item.HourStart.toString() + ':' +(item.MinuteStart <10? '0'+item.MinuteStart.toString(): item.MinuteStart.toString())+' '+'开始':
                  item.EndDate == this.currentDate?item.HourEnd.toString() + ':' +(item.MinuteEnd <10? '0'+item.MinuteEnd.toString(): item.MinuteEnd.toString())+' '+'结束':'全天'
                  )
                    .fontSize(15)
                    .offset({ x: 0, y: 10 })
                    .margin({ right: 10 })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('83%')
                .height('100%')
                .builder()
                .borderRadius(15)

              }
              .height('100%')
              .width('100%')
            }
            .height('10%')
            .width('100%')
          })
        }
        .height('70%')
        .width('95%')

      }.width('100%')
      .height('100%')
    }
}