import thermal from '@ohos.thermal'

@Component
@CustomDialog
export  struct DatePickerDialogPage {

  date:Date = new Date()

  @Link selectedHour:number

  @Link selectedMinute:number

  @Link day1:string

  @Link selectedYear:number

  @Link selectedMonth:number

  @Link selectedDate:number

  @Link fullDayFlag:boolean


  controller:CustomDialogController

  getDay(date:number):string{
    switch (date){
      case 0:
        return '日';
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
    }
  }
  build() {
    Column(){
      Text(this.selectedYear.toString()+'年'+this.selectedMonth.toString()+'月'+this.selectedDate.toString()+'日星期'+this.day1)
        .fontSize(20)
        .height('10%')
      Row() {
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected: new Date(this.selectedYear,this.selectedMonth-1,this.selectedDate)
        })
          .width(this.fullDayFlag == false? '60%':'100%')
          .height('40%')
          .onChange((value: DatePickerResult) => {

            this.selectedYear = value.year
            this.selectedMonth = value.month+1
            this.selectedDate = value.day

            let date = new Date(value.year,value.month,value.day)
            this.day1 = this.getDay(date.getDay())
          })
        TimePicker({
          selected:new Date(this.selectedYear,this.selectedMonth-1,this.selectedDate,this.selectedHour,this.selectedMinute)
        })
          .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)
          .width('20%')
          .height('40%')
          .useMilitaryTime(true)
          .onChange((value: TimePickerResult) => {
            this.selectedHour = value.hour
            this.selectedMinute = value.minute

            console.info('select current date is: ' + JSON.stringify(value))
          })
      }
    }
  }
}