import Foundation
import Observation

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case nutrition
    case training
    case progress
    case more

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Главная"
        case .nutrition: "Рацион"
        case .training: "Тренировки"
        case .progress: "Прогресс"
        case .more: "Ещё"
        }
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .nutrition: "fork.knife"
        case .training: "figure.strengthtraining.traditional"
        case .progress: "chart.line.uptrend.xyaxis"
        case .more: "ellipsis"
        }
    }
}

enum FitnessGoal: String, Codable, CaseIterable {
    case lose
    case maintain
    case gain

    var title: String {
        switch self {
        case .lose: "Снижение веса"
        case .maintain: "Поддержание"
        case .gain: "Набор массы"
        }
    }
}

enum MealSlot: String, Codable, CaseIterable {
    case breakfast = "Завтрак"
    case lunch = "Обед"
    case dinner = "Ужин"
    case snack = "Перекус"
}

struct Meal: Codable, Identifiable, Hashable {
    let id: UUID
    let slot: MealSlot
    let title: String
    let description: String
    let imageName: String
    let calories: Int
    let protein: Int
    let fat: Int
    let carbs: Int
    let ingredients: [String]
    let recipe: String
    let cookedWeight: Int
    var isCompleted: Bool

    static func standardPlan(profileID: UUID) -> [Meal] {
        [
            Meal(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                slot: .breakfast,
                title: "Овсянка с ягодами и йогуртом",
                description: "Медленные углеводы, йогурт и свежие ягоды",
                imageName: "FoodOatmeal",
                calories: 520,
                protein: 31,
                fat: 15,
                carbs: 62,
                ingredients: ["Овсянка — 80 г", "Греческий йогурт — 180 г", "Ягоды — 120 г", "Орехи — 15 г"],
                recipe: "Разогрейте овсянку с водой, добавьте йогурт, ягоды и орехи.",
                cookedWeight: 430,
                isCompleted: true
            ),
            Meal(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                slot: .lunch,
                title: "Курица терияки с рисом",
                description: "Куриное филе, овощи и бурый рис",
                imageName: "FoodBowl",
                calories: 690,
                protein: 54,
                fat: 18,
                carbs: 75,
                ingredients: ["Курица — 180 г", "Рис — 110 г", "Овощи — 180 г", "Соус терияки — 25 г"],
                recipe: "Обжарьте курицу без масла, добавьте овощи и соус, подавайте с рисом.",
                cookedWeight: 520,
                isCompleted: false
            ),
            Meal(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
                slot: .snack,
                title: "Творог, банан и корица",
                description: "Быстрый перекус после тренировки",
                imageName: "FoodSalad",
                calories: 310,
                protein: 28,
                fat: 8,
                carbs: 35,
                ingredients: ["Творог 5% — 180 г", "Банан — 110 г", "Корица — по вкусу"],
                recipe: "Смешайте ингредиенты, при необходимости добавьте немного воды.",
                cookedWeight: 290,
                isCompleted: false
            ),
            Meal(
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
                slot: .dinner,
                title: "Лосось с овощами",
                description: "Омега-3, зелень и запечённые овощи",
                imageName: "FoodSalmon",
                calories: 610,
                protein: 46,
                fat: 31,
                carbs: 34,
                ingredients: ["Лосось — 180 г", "Овощи — 250 г", "Оливковое масло — 8 г"],
                recipe: "Запекайте лосося и овощи 18–20 минут при 190 °C.",
                cookedWeight: 430,
                isCompleted: false
            )
        ]
    }
}

struct FoodEntry: Codable, Identifiable {
    let id: UUID
    var name: String
    var grams: Double
    var caloriesPer100: Double
    var proteinPer100: Double
    var fatPer100: Double
    var carbsPer100: Double
    var mealSlot: MealSlot
    var createdAt: Date

    var calories: Double { caloriesPer100 * grams / 100 }
    var protein: Double { proteinPer100 * grams / 100 }
    var fat: Double { fatPer100 * grams / 100 }
    var carbs: Double { carbsPer100 * grams / 100 }
}

struct WeightEntry: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let kilograms: Double
}

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let muscles: String
    let sets: Int
    let reps: String
    let rest: Int
    let instruction: String
    let icon: String
}

struct WorkoutProgram: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let duration: Int
    let level: String
    let calories: Int
    let exercises: [Exercise]
}

struct ShoppingItem: Codable, Identifiable {
    let id: UUID
    var title: String
    var quantity: String
    var store: String
    var estimatedPrice: Int
    var isChecked: Bool
}

struct Recipe: Codable, Identifiable {
    let id: UUID
    var title: String
    var calories: Int
    var protein: Int
    var ingredients: [String]
}

struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
    let date: Date
}

struct UserData: Codable, Identifiable {
    var id: UUID
    var name: String
    var goal: FitnessGoal
    var age: Int
    var height: Int
    var currentWeight: Double
    var targetWeight: Double
    var dailyCalories: Int
    var dailyProtein: Int
    var dailyFat: Int
    var dailyCarbs: Int
    var foods: [FoodEntry]
    var weights: [WeightEntry]
    var meals: [Meal]
    var shopping: [ShoppingItem]
    var recipes: [Recipe]
    var chat: [ChatMessage]
    var completedWorkouts: Int
    var waterLitres: Double
    var steps: Int

    var todayCalories: Double {
        let logged = foods.reduce(0) { $0 + $1.calories }
        let completedMeals = meals.filter(\.isCompleted).reduce(0) { $0 + $1.calories }
        return logged + Double(completedMeals)
    }

    var todayProtein: Double {
        let logged = foods.reduce(0) { $0 + $1.protein }
        let completedMeals = meals.filter(\.isCompleted).reduce(0) { $0 + $1.protein }
        return logged + Double(completedMeals)
    }

    var todayFat: Double {
        let logged = foods.reduce(0) { $0 + $1.fat }
        let completedMeals = meals.filter(\.isCompleted).reduce(0) { $0 + $1.fat }
        return logged + Double(completedMeals)
    }

    var todayCarbs: Double {
        let logged = foods.reduce(0) { $0 + $1.carbs }
        let completedMeals = meals.filter(\.isCompleted).reduce(0) { $0 + $1.carbs }
        return logged + Double(completedMeals)
    }

    var remainingCalories: Int {
        max(dailyCalories - Int(todayCalories), 0)
    }

    var weightProgress: Double {
        switch goal {
        case .gain:
            let start = max(currentWeight - 3, 0)
            return min(max((currentWeight - start) / max(targetWeight - start, 0.1), 0), 1)
        case .lose:
            let start = currentWeight + 3
            return min(max((start - currentWeight) / max(start - targetWeight, 0.1), 0), 1)
        case .maintain:
            return min(max(1 - abs(currentWeight - targetWeight) / 4, 0), 1)
        }
    }
}

enum DemoData {
    static let maleID = UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!
    static let femaleID = UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!

    static func profile(isMale: Bool) -> UserData {
        let id = isMale ? maleID : femaleID
        let name = isMale ? "Гулам" : "Анна"
        let current = isMale ? 82.4 : 64.2
        let target = isMale ? 88.0 : 58.0
        let goal: FitnessGoal = .gain
        let now = Date()

        let weights = [
            (-42, 79.5), (-35, 80.0), (-28, 80.1), (-21, 81.0),
            (-14, 81.4), (-7, 81.9), (-3, 82.1), (0, current)
        ].map {
            WeightEntry(
                id: UUID(),
                date: Calendar.current.date(byAdding: .day, value: $0.0, to: now) ?? now,
                kilograms: $0.1
            )
        }

        return UserData(
            id: id,
            name: name,
            goal: goal,
            age: isMale ? 36 : 32,
            height: isMale ? 181 : 168,
            currentWeight: current,
            targetWeight: target,
            dailyCalories: isMale ? 2650 : 2200,
            dailyProtein: isMale ? 180 : 140,
            dailyFat: isMale ? 82 : 72,
            dailyCarbs: isMale ? 300 : 240,
            foods: [
                FoodEntry(
                    id: UUID(),
                    name: "Кофе с молоком",
                    grams: 220,
                    caloriesPer100: 22,
                    proteinPer100: 1.2,
                    fatPer100: 1.1,
                    carbsPer100: 2.1,
                    mealSlot: .breakfast,
                    createdAt: now
                )
            ],
            weights: weights,
            meals: Meal.standardPlan(profileID: id),
            shopping: [
                ShoppingItem(id: UUID(), title: "Куриное филе", quantity: "1,2 кг", store: "Пятёрочка", estimatedPrice: 489, isChecked: false),
                ShoppingItem(id: UUID(), title: "Бурый рис", quantity: "800 г", store: "Дикси", estimatedPrice: 179, isChecked: true),
                ShoppingItem(id: UUID(), title: "Лосось", quantity: "500 г", store: "Пятёрочка", estimatedPrice: 699, isChecked: false),
                ShoppingItem(id: UUID(), title: "Овощная смесь", quantity: "900 г", store: "Дикси", estimatedPrice: 249, isChecked: false)
            ],
            recipes: [
                Recipe(
                    id: UUID(),
                    title: "Курица с рисом и овощами",
                    calories: 548,
                    protein: 44,
                    ingredients: ["Курица — 500 г", "Рис — 300 г", "Овощи — 250 г", "Масло — 20 г"]
                )
            ],
            chat: [
                ChatMessage(
                    id: UUID(),
                    text: "Я вижу ваш дневник и могу отвечать по реальным данным этого профиля. В локальном режиме запросы не отправляются на сервер.",
                    isUser: false,
                    date: now
                )
            ],
            completedWorkouts: isMale ? 3 : 2,
            waterLitres: 1.6,
            steps: isMale ? 7360 : 9120
        )
    }
}

@MainActor
@Observable
final class AppStore {
    var selectedTab: AppTab = .home
    var profiles: [UserData]
    var selectedProfileID: UUID
    var showFoodSheet = false
    var showWeightSheet = false
    var showScannerSheet = false
    var showChatSheet = false

    private let storageKey = "click.local.profiles.v1"
    private let selectedKey = "click.local.selected-profile.v1"

    init() {
        let fallback = [DemoData.profile(isMale: true), DemoData.profile(isMale: false)]
        let loadedProfiles: [UserData]
        if
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([UserData].self, from: data),
            decoded.count >= 2
        {
            loadedProfiles = decoded
        } else {
            loadedProfiles = fallback
        }

        let loadedSelection: UUID?
        if
            let raw = UserDefaults.standard.string(forKey: selectedKey),
            let id = UUID(uuidString: raw)
        {
            loadedSelection = id
        } else {
            loadedSelection = nil
        }

        profiles = loadedProfiles
        selectedProfileID = loadedProfiles.contains(where: { $0.id == loadedSelection })
            ? loadedSelection!
            : loadedProfiles[0].id
    }

    var current: UserData {
        get {
            profiles.first(where: { $0.id == selectedProfileID }) ?? profiles[0]
        }
        set {
            guard let index = profiles.firstIndex(where: { $0.id == newValue.id }) else { return }
            profiles[index] = newValue
            save()
        }
    }

    var weightProgressText: String {
        let delta = current.currentWeight - current.targetWeight
        if abs(delta) < 0.2 { return "Цель достигнута" }
        return "До цели \(abs(delta).formatted(.number.precision(.fractionLength(1)))) кг"
    }

    func switchProfile(to id: UUID) {
        guard profiles.contains(where: { $0.id == id }) else { return }
        selectedProfileID = id
        UserDefaults.standard.set(id.uuidString, forKey: selectedKey)
    }

    func toggleMeal(_ mealID: UUID) {
        guard let index = current.meals.firstIndex(where: { $0.id == mealID }) else { return }
        var updated = current
        updated.meals[index].isCompleted.toggle()
        current = updated
    }

    func addFood(
        name: String,
        grams: Double,
        caloriesPer100: Double,
        proteinPer100: Double,
        fatPer100: Double,
        carbsPer100: Double,
        slot: MealSlot
    ) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, grams > 0 else { return }
        var updated = current
        updated.foods.append(
            FoodEntry(
                id: UUID(),
                name: name,
                grams: grams,
                caloriesPer100: caloriesPer100,
                proteinPer100: proteinPer100,
                fatPer100: fatPer100,
                carbsPer100: carbsPer100,
                mealSlot: slot,
                createdAt: .now
            )
        )
        current = updated
    }

    func addWeight(_ kilograms: Double) {
        guard (35...250).contains(kilograms) else { return }
        var updated = current
        updated.currentWeight = kilograms
        updated.weights.append(WeightEntry(id: UUID(), date: .now, kilograms: kilograms))
        current = updated
    }

    func toggleShopping(_ id: UUID) {
        guard let index = current.shopping.firstIndex(where: { $0.id == id }) else { return }
        var updated = current
        updated.shopping[index].isChecked.toggle()
        current = updated
    }

    func completeWorkout() {
        var updated = current
        updated.completedWorkouts += 1
        current = updated
    }

    func sendCoachMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var updated = current
        updated.chat.append(ChatMessage(id: UUID(), text: trimmed, isUser: true, date: .now))
        updated.chat.append(
            ChatMessage(
                id: UUID(),
                text: coachReply(for: trimmed, user: updated),
                isUser: false,
                date: .now
            )
        )
        current = updated
    }

    private func coachReply(for text: String, user: UserData) -> String {
        let lower = text.lowercased()
        if lower.contains("бел") || lower.contains("осталось") {
            let left = max(user.dailyProtein - Int(user.todayProtein), 0)
            return "По текущему дневнику осталось \(left) г белка. Сейчас учтено \(Int(user.todayProtein)) г из \(user.dailyProtein) г."
        }
        if lower.contains("приготов") || lower.contains("рацион") || lower.contains("меню") {
            return "На сегодня по плану курица терияки с рисом и овощами. Если ужин нужен легче, замените лосося на белую рыбу — расчёт БЖУ обновится после подтверждения."
        }
        if lower.contains("вес") {
            let recent = user.weights.suffix(4).map(\.kilograms)
            let average = recent.isEmpty ? user.currentWeight : recent.reduce(0, +) / Double(recent.count)
            return "Текущий вес — \(user.currentWeight.formatted(.number.precision(.fractionLength(1)))) кг. Среднее последних измерений — \(average.formatted(.number.precision(.fractionLength(1)))) кг. Для вывода о тренде нужны регулярные утренние замеры."
        }
        if lower.contains("трениров") || lower.contains("нагруз") {
            return "В плане \(user.completedWorkouts) завершённые тренировки за неделю. Следующая нагрузка подбирается по самочувствию и истории; изменения плана требуют вашего подтверждения."
        }
        return "Я использовал только локальные данные профиля «\(user.name)». Уточните вопрос о питании, тренировке или весе — и я подставлю реальные показатели дневника."
    }

    func save() {
        if let data = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

enum WorkoutCatalog {
    static let plans = [
        WorkoutProgram(
            id: "upper",
            title: "Верх тела",
            subtitle: "Сила • грудь, спина, плечи",
            duration: 42,
            level: "Средний",
            calories: 360,
            exercises: [
                Exercise(name: "Отжимания", muscles: "Грудь · трицепс · плечи", sets: 4, reps: "8–12", rest: 75, instruction: "Держите корпус одной линией, локти под углом около 45°.", icon: "figure.strengthtraining.traditional"),
                Exercise(name: "Тяга гантелей в наклоне", muscles: "Спина · бицепс", sets: 4, reps: "10", rest: 90, instruction: "Стабилизируйте поясницу, тяните гантели к поясу.", icon: "dumbbell.fill"),
                Exercise(name: "Жим гантелей стоя", muscles: "Плечи · трицепс", sets: 3, reps: "10–12", rest: 75, instruction: "Не прогибайте поясницу, сохраняйте рёбра вниз.", icon: "figure.strengthtraining.functional"),
                Exercise(name: "Планка", muscles: "Кор", sets: 3, reps: "40 сек", rest: 45, instruction: "Напрягите ягодицы и пресс, дышите ровно.", icon: "figure.core.training")
            ]
        ),
        WorkoutProgram(
            id: "legs",
            title: "Низ тела",
            subtitle: "Сила • ноги, ягодицы",
            duration: 48,
            level: "Средний",
            calories: 410,
            exercises: [
                Exercise(name: "Приседания", muscles: "Квадрицепс · ягодицы", sets: 4, reps: "10–12", rest: 90, instruction: "Колени направляйте по линии стоп, сохраняйте стопы на полу.", icon: "figure.squat"),
                Exercise(name: "Румынская тяга", muscles: "Задняя поверхность бедра · ягодицы", sets: 4, reps: "10", rest: 90, instruction: "Отводите таз назад, сохраняйте нейтральную спину.", icon: "figure.strengthtraining.traditional"),
                Exercise(name: "Выпад назад", muscles: "Ягодицы · квадрицепс", sets: 3, reps: "10 на ногу", rest: 70, instruction: "Контролируйте колено передней ноги.", icon: "figure.walk.motion"),
                Exercise(name: "Ягодичный мост", muscles: "Ягодицы · кор", sets: 3, reps: "15", rest: 60, instruction: "В верхней точке напрягите ягодицы, не переразгибайте поясницу.", icon: "figure.core.training")
            ]
        ),
        WorkoutProgram(
            id: "home",
            title: "Дом без инвентаря",
            subtitle: "Мобильность • всё тело",
            duration: 28,
            level: "Лёгкий",
            calories: 220,
            exercises: [
                Exercise(name: "Приседания у стены", muscles: "Ноги · кор", sets: 3, reps: "12", rest: 45, instruction: "Мягко прижимайте спину, дышите спокойно.", icon: "figure.flexibility"),
                Exercise(name: "Отжимания от опоры", muscles: "Грудь · руки", sets: 3, reps: "10", rest: 45, instruction: "Опускайтесь медленно, корпус держите прямым.", icon: "figure.strengthtraining.functional"),
                Exercise(name: "Bird-dog", muscles: "Кор · спина", sets: 3, reps: "8 на сторону", rest: 40, instruction: "Не разворачивайте таз, тянитесь рукой и ногой.", icon: "figure.core.training")
            ]
        )
    ]
}

