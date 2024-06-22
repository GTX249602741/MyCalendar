import { Const, ScheduleModel } from '../model/ScheduleModel'
import { ToDo } from '../model/ToDo'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import observer from '@ohos.telephony.observer'
import thermal from '@ohos.thermal'

@Component
export struct Todo {

  date:Date = new Date()

  @State currentYear:number = this.date.getFullYear()

  @State currentMonth:number = this.date.getMonth()+1

  @State currentDate:number = this.date.getDate()

  @State rotateAngle:number = 0

  @State rotateAngle2:number = 0

  @State rotateAngle3:number = 0

  @State flag:boolean = true

  @State flag2:boolean = true

  @State flag3:boolean = true

  @Prop hasCalendar:boolean

  @Link scheduleModelArray:ScheduleModel[]

  @Link ArrayFinish:ScheduleModel[]

  @Link ArrayOutDated:ScheduleModel[]

  scroller:Scroller = new Scroller()

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})}



 // @State toDoArray:ToDo[] = [{desc:'待办',flag:this.flag,scheduleModelArray:this.scheduleModelArray},{desc:'完成',flag:this.flag2,scheduleModelArray:this.ArrayFinish},{desc:'过期',flag:this.flag3,scheduleModelArray:this.ArrayOutDated}]


 async getScheduleList(){
    this.scheduleModelArray = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.isNotNull("Title");
    predicates.equalTo('IsFinish',0)
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
          if ( i.EndDate >= this.currentDate) {
            this.scheduleModelArray.push(i)
          }
        }
      }
    }
    if(this.scheduleModelArray.length!=0){
      this.hasCalendar = true
    }
  }

  async getScheduleFinishList(){
    this.ArrayFinish = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',1);
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
    this.ArrayFinish.push(i)
    }
  }
  async getScheduleOutDatedList(){
    this.ArrayOutDated = []
    let predicates = new relationalStore.RdbPredicates("DATE");
    predicates.equalTo('IsFinish',0)
    let array = await dbUtil.queryForList(predicates, Const)
    for(let i of array){
      if (this.currentYear>i.EndYear) {
        this.ArrayOutDated.push(i)
        }
      if(this.currentYear = i.EndYear){
        if (this.currentMonth > i.EndMonth) {
          this.ArrayOutDated.push(i)
        }
        if (this.currentMonth = i.EndMonth) {
          if (this.currentDate > i.EndDate) {
            this.ArrayOutDated.push(i)
          }
        }
      }

      }
    }


  @Builder CustomBuilder(item:ScheduleModel) {
    Row() {
      Image($r('app.media.ic_public_ok_filled'))
        .size({ height: 20, width: 20 })
        .margin({ right: 10, left: 15 })
        .onClick(() => {
          AlertDialog.show(
            {
              message: '是否已完成？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  item.IsFinish = 1
                  let num = await dbUtil.update('DATE', item, Const, item.Title)
                  this.getScheduleList()
                  this.getScheduleFinishList()
                  this.getScheduleOutDatedList()

                }
              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
      Image($r('app.media.ic_public_delete'))
        .size({ height: 20, width: 20 })
        .margin({ right: 10 })
        .onClick(async () => {
          AlertDialog.show(
            {
              message: '是否确认删除？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                  console.info('Callback when the first button is clicked')
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  let predicates = new relationalStore.RdbPredicates("DATE");
                  predicates.equalTo('Title', item.Title);
                  let num = await dbUtil.delete(predicates)
                  this.getScheduleList()
                  this.getScheduleFinishList()
                  this.getScheduleOutDatedList()
                }

              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
    }
  }

  @Builder CustomBuilder2(item:ScheduleModel) {
    Row() {
      Image($r('app.media.ic_public_delete'))
        .size({ height: 20, width: 20 })
        .margin({ left: 15 })
        .onClick(async () => {
          AlertDialog.show(
            {
              message: '是否确认删除？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                  console.info('Callback when the first button is clicked')
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  let predicates = new relationalStore.RdbPredicates("DATE");
                  predicates.equalTo('Title', item.Title);
                  let num = await dbUtil.delete(predicates)
                  this.getScheduleList()
                  this.getScheduleFinishList()
                  this.getScheduleOutDatedList()
                }

              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
    }
  }

 build(){
    Scroll(this.scroller){
      Column(){
        Row(){
          Text('待办')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle})
            .onClick(()=>{
              this.rotateAngle = this.rotateAngle+180
              this.flag = !this.flag
            })
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')

        List(){
          ForEach(this.scheduleModelArray,(item:ScheduleModel)=>{
            ListItem(){
              Row() {
                Divider()
                  .vertical(true)
                  .color('#0091FF')
                  .height('70%')
                  .strokeWidth(4)
                  .lineCap(LineCapStyle.Round)
                  .margin({ left: 10, right: 10 })
                Text(item.Title)
                  .fontSize(25)

              }
              .borderRadius(15)
              .builder()
              .justifyContent(FlexAlign.Start)
              .height('7%')
              .width('95%')
            }
            .swipeAction({end:this.CustomBuilder(item)})
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag == true?Visibility.Visible:Visibility.None)

        Divider()

        Row(){
          Text('已完成')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle2})
            .onClick(()=>{
              this.rotateAngle2 = this.rotateAngle2+180
              this.flag2 = !this.flag2
            })
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')


        List(){
          ForEach(this.ArrayFinish,(item:ScheduleModel)=>{
            ListItem(){
              Row() {
                Divider()
                  .vertical(true)
                  .color('#0091FF')
                  .height('70%')
                  .strokeWidth(4)
                  .lineCap(LineCapStyle.Round)
                  .margin({ left: 10, right: 10 })
                Text(item.Title)
                  .fontSize(25)

              }
              .borderRadius(15)
              .builder()
              .justifyContent(FlexAlign.Start)
              .height('7%')
              .width('95%')
            }
            .swipeAction({end:this.CustomBuilder2(item)})
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag2 == true?Visibility.Visible:Visibility.None)

        Divider()

        Row(){
          Text('已过期')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle2})
            .onClick(()=>{
              this.rotateAngle2 = this.rotateAngle2+180
              this.flag3 = !this.flag3
            })
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')

        List(){
          ForEach(this.ArrayOutDated,(item:ScheduleModel)=>{
            ListItem(){
              Row() {
                Divider()
                  .vertical(true)
                  .color('#0091FF')
                  .height('70%')
                  .strokeWidth(4)
                  .lineCap(LineCapStyle.Round)
                  .margin({ left: 10, right: 10 })
                Text(){
                  Span(item.Title)
                    .fontSize(25)
                    .fontColor(Color.Red)
                    .decoration({type:TextDecorationType.LineThrough,color:Color.Red})
                }


              }
              .borderRadius(15)
              .builder()
              .justifyContent(FlexAlign.Start)
              .height('7%')
              .width('95%')
            }
            .swipeAction({end:this.CustomBuilder2(item)})
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag3 == true?Visibility.Visible:Visibility.None)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
   }
}

