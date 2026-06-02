// src/main/java/com/economiangola/domain/entity/PerfilEstudante.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "perfis_estudante")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilEstudante extends BaseEntity {

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false, unique = true)
    private Usuario usuario;

    @Column(name = "pontuacao_total", nullable = false)
    @Builder.Default
    private Integer pontuacaoTotal = 0;

    @Column(name = "quizzes_feitos", nullable = false)
    @Builder.Default
    private Integer quizzesFeitos = 0;

    @Column(name = "artigos_lidos", nullable = false)
    @Builder.Default
    private Integer artigosLidos = 0;

    @Column(name = "streak_dias", nullable = false)
    @Builder.Default
    private Integer streakDias = 0;

    @Column(name = "ultimo_acesso_em")
    private Instant ultimoAcessoEm;
}
