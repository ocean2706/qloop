
import XCTest
import QLoop

class QLoopMainThreadOperatorTests: XCTestCase {
    typealias Completion = (Int?) -> ()
    typealias ErrCompletion = (Error) -> ()
    typealias Operation = (Int?, @escaping Completion) -> ()
    typealias Handler = (Error, @escaping Completion, @escaping ErrCompletion) -> ()

    var subject: QLoopMainThreadOperation<Int>!

    override func setUp() {
        subject = QLoopMainThreadOperation()
    }

    func test_has_id() {
        XCTAssertEqual(subject.id, "main_thread")
    }

    func test_calling_operation_calls_completion_on_main_thread() throws {
        let expectMainThread = expectation(description: "expectMainThread")
        var thread: Thread? = nil
        let completion: Completion = { _ in
            thread = Thread.current;
            expectMainThread.fulfill()
        }

        subject.op(1, completion)

        wait(for: [expectMainThread], timeout: 3.0)
        XCTAssertNotNil(thread)
        XCTAssertTrue(thread?.isMainThread ?? false)
    }

    func test_calling_handler_calls_error_completion_on_main_thread() throws {
        let expectMainThread = expectation(description: "expectMainThread")
        var thread: Thread? = nil
        let completion: Completion = { _ in }
        let errCompletion: ErrCompletion = { _ in
            thread = Thread.current;
            expectMainThread.fulfill()
        }

        subject.err(QLoopError.Unknown, completion, errCompletion)

        wait(for: [expectMainThread], timeout: 3.0)
        XCTAssertNotNil(thread)
        XCTAssertTrue(thread?.isMainThread ?? false)
    }

    func test_segment_factory_function_connects_output_and_error_correctly() throws {
        let segment = QLoopMainThreadOperation<Int>.constructSegment()

        XCTAssertNotNil(segment.operation)
        XCTAssertEqual(segment.operationIds, ["main_thread"])
        XCTAssertTrue(segment.hasErrorHandler)
    }
}
