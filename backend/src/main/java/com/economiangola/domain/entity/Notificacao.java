// src/main/java/com/economiangola/domain/entity/Notificacao.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.TipoNotificacao;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "notificacoes")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Notificacao extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "titulo", nullable = false, length = 255)
    private String titulo;

    @Column(name = "mensagem", nullable = false, length = 1000)
    private String mensagem;

    @Column(name = "referencia_id")
    private Long referenciaId;

    @Enumerated(EnumType.STRING)
    @Column(name = "referencia_tipo", length = 30)
    private TipoNotificacao referenciaTipo;

    @Column(name = "lida", nullable = false)
    @Builder.Default
    private Boolean lida = false;

    @Column(name = "lida_em")
    private Instant lidaEm;
}
