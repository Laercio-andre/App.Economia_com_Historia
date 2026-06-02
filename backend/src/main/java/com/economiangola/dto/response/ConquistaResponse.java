// src/main/java/com/economiangola/dto/response/ConquistaResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.CriterioTipo;
import lombok.*;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConquistaResponse {

    private Long id;
    private String nome;
    private String descricao;
    private String iconeUrl;
    private CriterioTipo criterioTipo;
    private Integer criterioValor;
    private Integer pontosBonificacao;
    private Instant desbloqueadoEm;
}
