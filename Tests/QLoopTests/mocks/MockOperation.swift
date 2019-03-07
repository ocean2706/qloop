
import QLoop

class MockOp {

    static func IntToStr() -> QLoopSegment<Int, String>.Operation {
        return { input, compl in compl("\(input ?? -1)") }
    }

    static func AddToStr(_ value: String) -> QLoopSegment<String, String>.Operation {
        return { input, compl in compl((input ?? "") + value) }
    }

    static func VoidToStr(_ value: String? = nil) -> QLoopSegment<Void, String>.Operation {
        return { input, compl in compl(value) }
    }
}