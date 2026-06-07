import 'package:demo_app/features/skeleton/events/models/events_models/department_owner_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_agenda_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_date_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_flyer_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_id_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_invite_guest_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_maximum_capacity_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_summary_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_time_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_title_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_type_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/event_venue_data_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/has_reminder.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/has_survey_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/is_onsite_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/is_remote_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/reminder_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/requires_approval_model.dart';
import 'package:demo_app/features/skeleton/events/models/events_models/status_model.dart';
import 'package:demo_app/features/skeleton/events/models/survey_models/assigned_event_id_model.dart';

class EventsModel {
  final String? id;
  final String? eventCreator;
  final EventIdModel eventId;
  final EventTitleModel englishTitle;
  final EventTitleModel arabicTitle;
  final EventSummaryModel englishSummary;
  final EventSummaryModel arabicSummary;
  final EventAgendaModel englishAgenda;
  final EventAgendaModel arabicAgenda;
  final DepartmentOwnerModel departmentOwner;
  final EventDateModel eventDate;
  final EventTimeModel eventTime;
  final EventTypeModel eventType;
  final EventFlyerModel flyer;
  final IsRemoteModel isRemote;
  final IsOnSiteModel isOnSite;
  final EventVenueDataModel eventVenue;
  final EventMaximumCapacityModel maximumCapacity;
  final List<EventInviteGuestModel> invitedGuests;
  final HasReminder hasReminder;
  final List<EventReminderModel> eventReminders;
  final EventApprovalModel eventApproval;
  final HasSurveyModel hasSurvey;
  final AssignedId surveyId;
  final EventStatus status;

  EventsModel(
      {this.id,
      required this.eventCreator,
      required this.eventId,
      required this.englishTitle,
      required this.arabicTitle,
      required this.englishSummary,
      required this.arabicSummary,
      required this.englishAgenda,
      required this.arabicAgenda,
      required this.departmentOwner,
      required this.eventDate,
      required this.eventTime,
      required this.eventType,
      required this.flyer,
      required this.isRemote,
      required this.isOnSite,
      required this.eventVenue,
      required this.maximumCapacity,
      required this.invitedGuests,
      required this.hasReminder,
      required this.eventReminders,
      required this.eventApproval,
      required this.hasSurvey,
      required this.status,
      required this.surveyId});

  factory EventsModel.fromMap(String docId, Map data) {
    return EventsModel(
      eventCreator: data['Event_Creator'],
      id: docId,
      eventId: EventIdModel.fromMap(data['Event_Id']),
      englishTitle: EventTitleModel.fromMap(data['Title_English']),
      arabicTitle: EventTitleModel.fromMap(data['Title_Arabic']),
      arabicSummary: EventSummaryModel.fromMap(data['Summary_Arabic']),
      englishSummary: EventSummaryModel.fromMap(data['Summary_English']),
      arabicAgenda: EventAgendaModel.fromMap(data['Agenda_Arabic']),
      englishAgenda: EventAgendaModel.fromMap(data['Agenda_English']),
      departmentOwner: DepartmentOwnerModel.fromMap(data['Department_Owner']),
      eventDate: EventDateModel.fromMap(data['Date']),
      eventTime: EventTimeModel.fromMap(data['Time']),
      eventType: EventTypeModel.fromMap(data['Type']),
      flyer: EventFlyerModel.fromMap(data['Flyer']),
      isRemote: IsRemoteModel.fromMap(data['Is_Remote']),
      isOnSite: IsOnSiteModel.fromMap(data['Is_On_Site']),
      eventVenue: EventVenueDataModel.fromMap(data['Venue']),
      maximumCapacity:
          EventMaximumCapacityModel.fromMap(data['Maximum_Capacity']),
      invitedGuests: (data['Invited_Guests'] as List)
          .map((guest) => EventInviteGuestModel.fromMap(guest))
          .toList(),
      hasReminder: HasReminder.fromMap(data['Has_Reminder']),
      eventReminders: (data['Event_Reminders'] as List)
          .map((reminder) => EventReminderModel.fromMap(reminder))
          .toList(),
      eventApproval: EventApprovalModel.fromMap(data['Event_Approval']),
      hasSurvey: HasSurveyModel.fromMap(data['Has_Survey']),
      status: EventStatus.fromMap(data['Status']),
      surveyId: AssignedId.fromMap(data['Survey_Id']),
    );
  }

  Map<String, dynamic> toMap() => {
        'Event_Creator': eventCreator,
        'Event_Id': eventId.toMap(),
        'Title_English': englishTitle.toMap(),
        'Title_Arabic': arabicTitle.toMap(),
        'Summary_Arabic': arabicSummary.toMap(),
        'Summary_English': englishSummary.toMap(),
        'Agenda_Arabic': arabicAgenda.toMap(),
        'Agenda_English': englishAgenda.toMap(),
        'Department_Owner': departmentOwner.toMap(),
        'Date': eventDate.toMap(),
        'Time': eventTime.toMap(),
        'Type': eventType.toMap(),
        'Flyer': flyer.toMap(),
        'Is_Remote': isRemote.toMap(),
        'Is_On_Site': isOnSite.toMap(),
        'Venue': eventVenue.toMap(),
        'Maximum_Capacity': maximumCapacity.toMap(),
        'Invited_Guests': invitedGuests.map((guest) => guest.toMap()).toList(),
        'Has_Reminder': hasReminder.toMap(),
        'Event_Reminders':
            eventReminders.map((reminder) => reminder.toMap()).toList(),
        'Event_Approval': eventApproval.toMap(),
        'Has_Survey': hasSurvey.toMap(),
        'Status': status.toMap(),
        'Survey_Id': surveyId.toMap(),
      };
}
