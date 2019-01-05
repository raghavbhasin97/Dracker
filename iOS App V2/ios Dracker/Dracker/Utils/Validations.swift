import Foundation

let DESCRIPTION_MAX_LIMIT = 50
let DESCRIPTION_MIN_LIMIT = 5

let NOTE_MAX_LIMIT = 280
let NOTE_MIN_LIMIT = 5


func validEmail(email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,3}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
}

func validPassword(password: String) -> Bool {
    return password.count > 5
}

func validAmount(amount: String) -> Bool {
    let regex = "[0-9]+\\.[0-9]{2}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: amount)
}

func validDescription(description: String) -> Bool {
    let desc = description.trimmingCharacters(in: .whitespaces)
    return desc.count > (DESCRIPTION_MIN_LIMIT - 1) && desc.count < (DESCRIPTION_MAX_LIMIT + 1)
}

func validFrequency(freq: String) -> Bool {
    let integerFreq = Int(freq) ?? 0
    return integerFreq > 0 && integerFreq < 8
}
