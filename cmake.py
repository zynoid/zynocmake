from argparse import ArgumentParser
from typing import Optional, Callable
import os
os.chdir(f"{os.path.dirname(__file__)}/..")

class Args:
    handle: Callable[["Args"], None]
    target: Optional[str]
    need_build: bool = False

def build(args: Args):
    if args.target:
        print(f"build {args.target}")
    else:
        print("build all")
    os.system("mkdir -p build bin lib")
    os.system("cmake -B ./build/")
    if args.target:
        print(f"build {args.target}")
        os.system(f"cmake --build ./build/ --target {args.target}")
    else:
        print("build all")
        os.system("cmake --build ./build/")

def test(args: Args):
    if args.need_build:
        build(args)
    if args.target:
        print(f"test {args.target}")
    else:
        print("test all")
    os.chdir("./build")
    if args.target:
        os.system(f"ctest -R {args.target} --output-on-failure")
    else:
        os.system("ctest --output-on-failure")

def run(args: Args):
    if args.need_build:
        build(args)
    print("==================== run =====================")
    os.system(f"./bin/{args.target}")

if __name__ == "__main__":
    parser = ArgumentParser(prog='cmake')
    sub_parsers = parser.add_subparsers()

    build_parser = sub_parsers.add_parser('build', help="编译")
    build_parser.add_argument('-t', '--target', help="build target", required=False, type=str)
    build_parser.set_defaults(handle=build)

    test_parser = sub_parsers.add_parser('test', help="测试")
    test_parser.add_argument('-t', '--target', help="test target", required=False, type=str)
    test_parser.add_argument(
        '-b', '--build', help="need rebuild", required=False, action="store_true", dest="need_build")
    test_parser.set_defaults(handle=test)

    run_parser = sub_parsers.add_parser('run', help="运行")
    run_parser.add_argument('-t', '--target', help="run target", required=True, type=str)
    run_parser.add_argument(
        '-b', '--build', help="need rebuild", required=False, action="store_true", dest="need_build")
    run_parser.set_defaults(handle=run)

    args = Args()
    parser.parse_args(namespace=args)
    args.handle(args)