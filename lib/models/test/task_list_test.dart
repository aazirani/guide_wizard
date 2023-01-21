import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/task/task_list.dart' as tl;
import 'package:boilerplate/models/technical_name/technical_name.dart';
import 'package:boilerplate/models/translation/translation_list.dart';

tl.TaskList taskList = tl.TaskList(
    tasks: List<Task>.generate(
  10,
  (index) => Task(
    id: 0,
    text: TechnicalName(
        id: 1,
        technical_name: "Housing",
        translations: TranslationList(translations: []),
        creator_id: 1,
        created_at: "0",
        updated_at: "0"),
    description: TechnicalName(
        id: 1,
        technical_name: "Housing",
        translations: TranslationList(translations: []),
        creator_id: 1,
        created_at: "0",
        updated_at: "0"),
    type: "sth",
    sub_tasks: List<SubTask>.generate(
        10,
        (index) => SubTask(
            id: 1,
            task_id: 0,
            title: TechnicalName(
                id: 0,
                technical_name: "Dorm",
                translations: TranslationList(translations: []),
                creator_id: 1,
                created_at: "0",
                updated_at: "0"),
            markdown: TechnicalName(
                id: 1,
                technical_name: "markdown",
                translations: TranslationList(translations: []),
                creator_id: 1,
                created_at: "0",
                updated_at: "0"),
            deadline: TechnicalName(
                id: 1,
                technical_name: "deadline",
                translations: TranslationList(translations: []),
                creator_id: 1,
                created_at: "0",
                updated_at: "0"),
            order: 1,
            creator_id: "1",
            created_at: "0",
            updated_at: "0")),
    creator_id: "1",
    created_at: "0",
    updated_at: "0",
    image1: null,
    image2: null,
    fa_icon: null,
    quesions: [],
  ),
));
