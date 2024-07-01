import { CJCalendar, OptMode, Solar } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { Const, ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import {getScheduleList} from './Index'
@Component
@CustomDialog
export  struct MonthDialogPage {

  controller:CustomDialogController

  @Link currentYear:number

  @Link currentMonth:number

  @Link currentDate:number

  @Link currentHour:number

  @Link currentMinute:number
  // 由Index传入，存放指定日期的日程数组
  @Link scheduleModelArray:Array<ScheduleModel>

  date:Date = new Date()

  @State item:CJDateItem[] = []

  aboutToAppear(): void {

    let today: CJDateItem = new CJDateItem(this.date,null,null,Solar.fromDate(this.date))

    this.item[0] = today
  }


  build() {
    Column(){
      CJCalendar({currentYear:$currentYear,currentMonth:$currentMonth,showLunar:true,onSelectedChanged:(item:CJDateItem[])=>{
        this.item = item
        this.currentYear = item[0].fullYear
        this.currentMonth = item[0].month+1
        this.currentDate = item[0].date

        getScheduleList(this.currentYear,this.currentMonth,this.currentDate).then((result:ScheduleModel[])=>{
          this.scheduleModelArray = result
        }).catch((err)=>{
          console.log(err)
        })

      },optMode:OptMode.SINGLE})
    }

  }
}