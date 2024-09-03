variables.tf 동작원리에 대한 간단한 이해

1. 서브모듈의 variable.tf에 정의된 변수(필수변수, 선택적 변수 전부)는 서브모듈의 main.tf에서 반드시 사용될 필요없다
2. 루트모듈에서 서브모듈을 호출할때에는 서브모듈에 선언된 필수변수는 반드시 들어가야한다.

ex) 
sub_module/main.tf

resource {
    AWS_ATTRIBUTE = var.variable1
    AWS_ATTRIBUTE = resource."pname".id
}

sub_module/variables.tf

variable "variable1" {
 
    default = [] // default 값이 있음, 선택적 변수
    " "          // 기본값이 없음 >> 필수 변수
}


sub_module/main.tf <-> sub_module/variables.tf
variables.tf에 선언된 변수(필수변수)가 반드시 사용될 필요는 없음

root_module/main.tf <-> sub_module/variables.tf
variables.tf에 선언된 필수변수는 반드시 전부 사용되어야 함

종합적으로 이해해보자면, 모듈을 호출하기 위한 재료는 전부 다 구비가 되어있어야 호출이 가능하지만, 그걸 이용하는건 모듈 마음.
이렇게 이해를 해두자






자동으로 생성된 값을 생성시 설정으로 만들어야 한다면

1. 서브모듈에서 해당 값을 생성하는 리소스 생성
2. 로컬변수에 저장
3. 서브모듈의 다른 리소스에서 해당 값을 받아오도록 함
>> variable.tf에 정의할 필요가 없게됨
(글만 보면 당연한 말이지만, 기존의 흐름과 대비됨)