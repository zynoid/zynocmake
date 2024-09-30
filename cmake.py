#!/usr/bin/python3
from argparse import ArgumentParser
from typing import Optional, Callable, List
import os
# os.chdir(f"{os.path.dirname(__file__)}/..")

class Args:
    handle: Callable[["Args"], None]
    target: Optional[str]
    need_build: bool = False
    run_args: List[str]

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
    run_args = " ".join(args.run_args)
    os.system(f"./bin/{args.target} {run_args}")

if __name__ == "__main__":
    parser = ArgumentParser(prog='cmake')
    sub_parsers = parser.add_subparsers()

    build_parser = sub_parsers.add_parser('build', help="编译")
    build_parser.add_argument('target', help="build target", type=str, default=None, nargs="?")
    build_parser.set_defaults(handle=build)

    test_parser = sub_parsers.add_parser('test', help="测试")
    test_parser.add_argument('target', help="test target", type=str, default=None, nargs="?")
    test_parser.add_argument(
        '-b', '--build', help="need rebuild", required=False, action="store_true", dest="need_build")
    test_parser.set_defaults(handle=test)

    run_parser = sub_parsers.add_parser('run', help="运行")
    run_parser.add_argument('target', help="run target", type=str)
    run_parser.add_argument(
        '-b', '--build', help="need rebuild", required=False, action="store_true", dest="need_build")

    run_parser.set_defaults(handle=run)

    args = Args()
    _, args.run_args = parser.parse_known_args(namespace=args)
    args.handle(args)