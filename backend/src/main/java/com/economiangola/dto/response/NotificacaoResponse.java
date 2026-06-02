// src/main/java/com/economiangola/dto/response/NotificacaoResponse.java
package com.economiangola.dto.response;

import com.economiangola.domain.enums.TipoNotificacao;
import lombok.*;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificacaoResponse {

    private Long id;
    private String titulo;
    private String mensagem;
    private TipoNotificacao referenciaTipo;
    private Long referenciaId;
    private Boolean lida;
    private Instant lidaEm;
    private Instant criadoEm;
}
